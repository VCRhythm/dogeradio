class UsersController < ApplicationController
  before_action :set_user, only: [:show, :autopay, :payout, :pay, :update_balance]

	def soundcloud_auth
		$soundcloud_id = Rails.configuration.apis[:soundcloud_id]
		$soundcloud_secret = Rails.configuration.apis[:soundcloud_secret]
		client = SoundCloud.new({
			client_id: $soundcloud_id,
			client_secret: $soundcloud_secret,
			redirect_uri: 'http://www.dogeradio.com/soundcloud_callback',
			scope: 'non-expiring',
			display: 'popup'
		})	
		redirect_to client.authorize_url()
	end

	def soundcloud_callback
		client = SoundCloud.new({
			client_id: $soundcloud_id,
			client_secret: $soundcloud_secret,
			redirect_uri: 'http://www.dogeradio.com/soundcloud_callback'
		})	
		code = params[:code]
		access_token = client.exchange_token(code: code)
		current_user.soundcloud_access_token = access_token.access_token
		current_user.save
		client = SoundCloud.new(access_token: current_user.soundcloud_access_token)
		soundcloud_tracks = client.get('/me/tracks')
		soundcloud_tracks.each do |track|
			current_user.tracks.create(name:track.title, url: track.stream_url+'?client_id='+Rails.configuration.apis[:soundcloud_id], source: "soundcloud")
		end
		redirect_to root_url
	end

	def show
		@playlist = current_user.playlists.first
		@tracks = @user.tracks.order(created_at: :desc)
	end

	def payout
		@amount = params[:amount].to_f
		if @this_user.balance >= @amount
			@this_user.payouts.create(value:@amount)
			@this_user.balance -= @amount
			@this_user.save
		end
	end

	def autopay
	end

	def pay
		@track = Track.find(params[:track_id])
		@amount = @this_user.default_tip_amount
		@fee = @this_user.transaction_fee * @amount

		if @this_user.balance >= @amount
			@this_user.balance -= (@amount + @fee)
			@user.balance += @amount
			@this_user.save
			@user.save
			Transaction.create(payer_id:@this_user.id, payee_id:@user.id, value:@amount, method: "tip", track_id:@track.id)
			Transaction.create(payer_id:@this_user.id, payee_id:0, value:@fee, method: "fee")
		else
			render layout: false
		end
	end

	def index
		@users = User.all
	end

	def update_balance
		current_balance = @this_user.balance
		require 'doge_api'
		$my_api_key = Rails.configuration.apis[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key)
		current_received = doge_api.get_address_received(payment_address: @this_user.account).to_f
		@this_user.balance += current_received - @this_user.prev_received
		if @this_user.balance != current_balance
			@this_user.prev_received = current_received
			@this_user.save
		end
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
			@this_user = current_user
    end

end
