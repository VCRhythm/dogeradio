class RegistrationsController < Devise::RegistrationsController
	before_filter :layout_container, only: [:edit]

	def edit
		choose_layout
	end

	def update
		expire_page controller: :users, action: :show, username: current_user.username
		@user = User.find(current_user.id)
		successfully_updated = if needs_password?(@user, params)
			@user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
		else
			params[:user].delete(:current_password)
			@user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
		end

		if successfully_updated
			set_flash_message :notice, :updated
			sign_in @user, bypass: true
			redirect_to @user
		else
			render "edit"
		end
	end

	def sign_up(resource_name, resource)
		resource.playlists.create(name:"primary")
		resource.account = get_doge_api_address
		resource.save
		sign_in(resource_name, resource)
	end

	private
	def choose_layout
		respond_to do |format|
			format.html
			format.js { render layout: "events"}
		end
	end
	def layout_container
		@layout_container = "main-body"
	end
	def get_doge_api_address
		require 'doge_api'
		$my_api_key = Rails.configuration.apis[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key, version=2)
		account = doge_api.get_new_address address_label: resource.username
		return JSON.parse(account)["data"]["address"]
	end

	def needs_password?(user, params)
		user.email != params[:user][:email] || params[:user][:password].present?
	end

end
