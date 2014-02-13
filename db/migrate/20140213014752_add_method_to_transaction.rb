class AddMethodToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :method, :string
  end
end
