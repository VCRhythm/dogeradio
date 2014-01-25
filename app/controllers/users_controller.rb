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
end
