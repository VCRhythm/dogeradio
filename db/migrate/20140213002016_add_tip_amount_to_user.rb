class AddTipAmountToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_tip_amount, :float
    add_column :users, :wow_tip_amount, :float
    add_column :users, :donation_percent, :float
    add_column :users, :transaction_fee, :float
  end
end
