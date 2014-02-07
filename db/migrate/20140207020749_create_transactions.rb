class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :payee_id
      t.integer :payer_id
      t.float :value
      t.string :type

      t.timestamps
    end
  end
end
