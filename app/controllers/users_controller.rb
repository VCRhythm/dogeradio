class UsersController < ApplicationController
  before_action :set_user, only: [:show, :payout, :pay]
	before_action :this_user, only: [:update_balance, :pay, :payout, :autopay]

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
		@method = params[:category]
		if params[:track_id]
			@track_id = params[:track_id]
		else
			@track_id = 0
		end

		if signed_in? && pay_user(@user, @this_user.default_tip_amount, @method, @track_id)
			render 'pay'
		else
			render 'nopay'
		end
	end

	def index
		@users = User.all
	end

	def update_balance
		require 'doge_api'
		$my_api_key = Rails.configuration.apis[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key)
		current_received = doge_api.get_address_received(payment_address: @this_user.account).to_f
		if @this_user.prev_received < current_received
			@this_user.balance += current_received - @this_user.prev_received
			@this_user.prev_received = current_received
			@this_user.pending_tips.each do |tip|
				if pay_user(User.find(tip.payee_id), tip.value, tip.id, tip.track_id )
					tip.pending = false
					tip.save
				end
			end
			@this_user.save
		end
	end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.permit(:username, :track_id, :code, :amount, :category)
    end

		def pay_user(user, amount, method, track_id)
			fee = @this_user.transaction_fee
			donation = @this_user.donation_percent * amount
			if (@this_user.balance > amount + fee + donation) && (@this_user != user)
				@this_user.balance -= (amount + fee + donation)
				user.balance += amount
				@this_user.save
				user.save
				Transaction.create(payer_id: @this_user.id, payee_id: user.id, value: amount, method: method, track_id: track_id, pending: false)
				Transaction.create(payer_id: @this_user.id, payee_id: 0, value: fee, method: "fee", pending:false)
				Transaction.create(payer_id: @this_user.id, payee_id:0, value: donation, method: "donation", pending: false)
				true
			else
				false
			end
		end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where('lower(username) = ?', params[:username].downcase).first
    end

		def this_user
			@this_user = current_user
		end

end
