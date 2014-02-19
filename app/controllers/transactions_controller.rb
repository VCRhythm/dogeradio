class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show]

	def hold_charge
		@user_id = params[:user_id]
		if params[:track_id]
			@track_id = params[:track_id]
		else
			@track_id = 0
		end

		if signed_in?
			@this_user = current_user
			@amount = @this_user.default_tip_amount
			@donation = @amount * @this_user.donation_percent
			@fee = @this_user.transaction_fee
			Transaction.create(payer_id:@this_user.id, payee_id:@user_id, value:@amount, method: params[:category], track_id:@track_id, pending: true)
			Transaction.create(payer_id:@this_user.id, payee_id:0, value:@donation, method: "donation", pending: true)
			Transaction.create(payer_id:@this_user.id, payee_id:0, value:@fee, method: "fee", pending: true)
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
      params.require(:transaction).permit(:payee_id, :track_id, :payer_id, :amount, :method)
    end
end
