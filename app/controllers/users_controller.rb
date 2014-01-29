class UsersController < ApplicationController
	def pay
		@user = current_user
    @user_to_pay = User.find(params[:user_id])
		@music = Music.find(params[:music_id])
		@amount = 5

		if @user.balance > @amount
			@user.balance -= @amount
			@user_to_pay.balance += @amount
			@user.save
			@user_to_pay.save
		else
			render layout: false
		end
	end

	def update_balance
		@user = current_user
		require 'doge_api'
		$my_api_key = Rails.configuration.aws[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key)
		@user.balance += (doge_api.get_address_received payment_address: @user.account) - @user.prev_received
	end
end
