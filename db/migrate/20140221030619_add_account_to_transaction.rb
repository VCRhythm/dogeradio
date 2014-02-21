class AddAccountToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :account, :string
  end
end
