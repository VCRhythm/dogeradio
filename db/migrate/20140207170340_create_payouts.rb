class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.belongs_to :user, index: true
      t.float :value
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
