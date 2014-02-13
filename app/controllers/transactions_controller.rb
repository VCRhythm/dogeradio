class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show]

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
      params.require(:transaction).permit(:payee_id, :payer_id, :amount, :method)
    end
end
