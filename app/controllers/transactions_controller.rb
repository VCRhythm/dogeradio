class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show]

	def index
		@user = current_user
		@balance = @user.balance
		@transactions = @user.tips_received
		@transactions << @user.tips_given
		@deposits = @user.prev_received
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:payee_id, :payer_id, :amount, :type)
    end
end
