class AddPayoutAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payout_account, :string
  end
end
