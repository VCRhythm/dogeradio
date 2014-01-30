class RegistrationsController < Devise::RegistrationsController
	def update
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
			redirect_to after_update_path_for(@user)
		else
			render "edit"
		end
	end

	def sign_up(resource_name, resource)
		resource.playlists.create(name:"primary")
		require 'doge_api'
		$my_api_key = Rails.configuration.aws[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key)
		resource.account = doge_api.get_new_address address_label: resource.username
		resource.save
		sign_in(resource_name, resource)
	end
	
	private

	def needs_password?(user, params)
		user.email != params[:user][:email] || params[:user][:password].present?
	end

end
