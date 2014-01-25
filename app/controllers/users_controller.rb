class UsersController < ApplicationController
	def pay
    @user_to_pay = User.find(params[:user_id])
		@music = Music.find(params[:music_id])
		@amount = 5

		if current_user.balance > @amount
			current_user.balance -= @amount
			@user_to_pay.balance += @amount
			@user_to_pay.save
		else
			render layout: false
		end
	end
end
