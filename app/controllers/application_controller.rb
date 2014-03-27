class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception
	before_filter :configure_permitted_parameters, if: :devise_controller?
	before_action :set_transactions
	before_action :set_queue
	around_filter :user_time_zone, if: :current_user
	geocode_ip_address

	def user_time_zone(&block)
		Time.use_zone(current_user.time_zone, &block)
		Chronic.time_class = Time.zone
	end

	# if user is logged in, return current_user, else return guest_user
	def current_or_guest_user
		if current_user
			if session[:guest_user_id]
				logging_in
				guest_user.destroy
				session[:guest_user_id] = nil
			end
			current_user
		else
			guest_user
		end
	end

	# find guest_user object associated with the current sessions, creating one as needed
	def guest_user
		# Cache the value  the first time it's gotten.
		@cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
	rescue ActiveRecord::RecordNotFound #if sessions[:guest_user_id] invalid
		session[:guest_user_id] = nil
		guest_user
	end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :code, :password_confirmation, :remember_me) }
		devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me)}
		devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:time_zone, :username, :avatar, :bio, :payout_account, :email, :password, :password_confirmation, :current_password, :website, :autotip, :default_tip_amount, :donation_percent, :address, :publish_address, :display_name) }
	end

	private

	def logging_in
	end

	def create_guest_user
		u = User.create(username: "guest"+SecureRandom.base64, email: "guest_#{Time.now.to_i}#{rand(99)}@dogeradio.com", guest: true, display_name: "Guest")
		u.save!(validate: false)
		@playlist = u.playlists.create(name: "queue", category: "queue")
		@playlist.tracks = Track.order(created_at: :desc).limit(20)
		session[:guest_user_id] = u.id
		u
	end

	def location
		if params[:location].blank?
			if !session[:geo_location].blank?
				@location ||= session[:geo_location]
			elsif Rails.env.test? || Rails.env.development?
				@location ||= Geokit::Geocoders::MultiGeocoder.geocode("69.243.26.55")
			else
				@location ||= Geokit::Geocoders::MultiGeocoder.geocode("Pullman, WA, USA")
			end
		else
			params[:location].each {|l| l = l.to_i } if params[:location].is_a? Array
			@location ||= Geokit::Geocoders::MultiGeocoder.geocode(params[:location])
			session[:geo_location] = @location
		end
		@location
	end

	def set_transactions
		@transactions = Transaction.ten_recent
	end

	def set_queue
		@user = current_or_guest_user
		@playlist = @user.queue
		@playlist ||= @user.playlists.create(name:"queue", category:"queue")
		#Tell the player to play track 1
		@player_position = 1 #needed for next functionality
		@track = @playlist.tracks[0]
	end

end