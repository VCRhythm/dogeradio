class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	before_filter :configure_permitted_parameters, if: :devise_controller?
	before_action :set_transactions
	before_action :set_queue, unless: :has_queue?

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :code, :password_confirmation, :remember_me) }
		devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me)}
		devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :avatar, :bio, :payout_account, :email, :password, :password_confirmation, :current_password, :website, :autotip, :default_tip_amount, :donation_percent, :address, :publish_address, :display_name) }
	end

	private

	def location
		if params[:location].blank?
			if Rails.env.test? || Rails.env.development?
				@location ||= Geocoder.search("50.78.167.161").first
			else
				@location ||= request.location
			end
		else
			params[:location].each {|l| l = l.to_i } if params[:location].is_a? Array
			@location ||= Geocoder.search(params[:location]).first
		end
		return @location
	end

	def set_transactions	
		@transactions = Transaction.ten_recent
	end

	def has_queue?
		@playlist
	end

	def set_queue
		if signed_in?
			@user = current_user
			@playlist = @user.queue
			@playlist ||= @user.playlists.create(name:"queue", category:"queue")
		else
			@playlist = Playlist.create(user_id:0, name: "guest_playlist")
			@playlist.tracks = Track.order(created_at: :desc).limit(20)
		end

		#Tell the player to play track 1
		@player_position = 1 #needed for next functionality
		@track = @playlist.tracks[0]
	end
end
