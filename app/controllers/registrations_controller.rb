class RegistrationsController < Devise::RegistrationsController
	def sign_up(resource_name, resource)
		require 'doge_api'
		$my_api_key = Rails.configuration.aws[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key)
		resource.account = doge_api.get_new_address address_label: resource.username
		resource.save
		sign_in(resource_name, resource)
	end
end
