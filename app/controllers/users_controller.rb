class UsersController < ApplicationController
	def show
 		@user = User.find(params[:id])
		@musics = @user.musics.order(created_at: :desc).where(processed: true)
	end

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
		current_balance = @user.balance
		require 'doge_api'
		$my_api_key = Rails.configuration.aws[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key)
		current_received = doge_api.get_address_received(payment_address: @user.account).to_f
		@user.balance += current_received - @user.prev_received
		if @user.balance != current_balance
			@user.prev_received = current_received
			@user.save
		end
	end
end
