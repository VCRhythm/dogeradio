class AddTipAmountToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_tip_amount, :float, default: 5.0
    add_column :users, :wow_tip_amount, :float, default: 5.0
    add_column :users, :donation_percent, :float, default: 0.0
    add_column :users, :transaction_fee, :float, default: 0.04
  end
end
