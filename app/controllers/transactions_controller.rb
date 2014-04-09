class TransactionsController < ApplicationController
  	before_action :set_transaction, only: [:show]

	def guest_charge
		if simple_captcha_valid?
			@transaction = Transaction.new(transaction_params)
			@transaction.payer_id = 0
			@transaction.pending = true
			@transaction.account = get_doge_api_address(@transaction.email)
			if @transaction.account && @transaction.save
				render 'guest_pay.js.erb'
			end
		else
			render 'captcha_fail.js.erb'
		end
	end

	def hold_charge
		if signed_in?
			@transaction = Transaction.new(transaction_params)
			@this_user = current_user
			@transaction.value = @this_user.default_tip_amount
			@transaction.email = @this_user.email
			@transaction.payer_id = @this_user.id
			@transaction.pending = true
			@transaction.save
			render 'users/pay'
		end
	end

	def index
		@user = current_user
		@balance = @user.balance
		@payout_sum = @user.payouts.sum(:value)
		@tips_received_sum = @user.tips_received.sum(:value)
		@tips_given_sum = @user.tips_given.sum(:value)
		@deposits_sum = @user.prev_received || 0.0
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:commit, :payee_id, :track_id, :payer_id, :value, :method, :email)
    end

	def get_doge_api_address(label)
		require 'doge_api'
		$my_api_key = Rails.configuration.apis[:doge_api_key]
		doge_api = DogeApi::DogeApi.new($my_api_key, version=2)
		account = doge_api.get_new_address address_label: label
		return JSON.parse(account)["data"]["address"]
	end
end
