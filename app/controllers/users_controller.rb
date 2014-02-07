class UsersController < ApplicationController
  before_action :set_user, only: [:show ]
	before_action :this_user, only: [:payout, :pay, :update_balance]

	def show
		@playlist = current_user.playlists.first
		@musics = @user.musics.order(created_at: :desc).where(processed: true)
	end

	def payout
		@amount = params[:amount].to_f
		if @user.balance >= @amount
			@user.payouts.create(value:@amount)
			@user.balance -= @amount
			@user.save
		end
	end

	def pay
    @user_to_pay = User.find(params[:user_id])
		@music = Music.find(params[:music_id])
		@amount = 5

		if @user.balance >= @amount
			@user.balance -= @amount
			@user_to_pay.balance += @amount
			@user.save
			@user_to_pay.save
			Transaction.create(payer_id:@user.id, payee_id:@user_to_pay.id, value:@amount, type:"tip")
		else
			render layout: false
		end
	end

	def update_balance
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

		def this_user
			@user = current_user
		end
end
