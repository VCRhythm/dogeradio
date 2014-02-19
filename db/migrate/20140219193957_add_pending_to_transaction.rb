class AddPendingToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :pending, :boolean, default: true
  end
end
