class UsersController < ApplicationController
  before_action :set_user, only: [:show ]
	before_action :this_user, only: [:payout, :pay, :update_balance]

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
#		client = Soundcloud.new(access_token: @user.soundcloud_access_token)
		@playlist = current_user.playlists.first
		@tracks = @user.tracks.order(created_at: :desc)
	end

	def payout
		@amount = params[:amount].to_f
		if @user.balance >= @amount
			@user.payouts.create(value:@amount)
			@user.balance -= @amount
			@user.save
		end
	end

	def pay
    @user_to_pay = User.find(params[:user_id])
		@track = Track.find(params[:track_id])
		@amount = @user.default_tip_amount
		@fee = @user.transaction_fee * @amount

		if @user.balance >= @amount
			@user.balance -= (@amount + @fee)
			@user_to_pay.balance += @amount
			@user.save
			@user_to_pay.save
			Transaction.create(payer_id:@user.id, payee_id:@user_to_pay.id, value:@amount, method: "tip")
			Transaction.create(payer_id:@user.id, payee_id:0, value:@fee, method: "fee")
		else
			render layout: false
		end
	end

	def index
		@users = User.all
	end

	def update_balance
		current_balance = @user.balance
		require 'doge_api'
		$my_api_key = Rails.configuration.apis[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key)
		current_received = doge_api.get_address_received(payment_address: @user.account).to_f
		@user.balance += current_received - @user.prev_received
		if @user.balance != current_balance
			@user.prev_received = current_received
			@user.save
		end
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

		def this_user
			@user = current_user
		end
end
