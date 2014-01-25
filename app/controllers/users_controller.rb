class UsersController < ApplicationController
	def pay
    @user_to_pay = User.find(params[:user_id])
		@amount = 5
	end
end
