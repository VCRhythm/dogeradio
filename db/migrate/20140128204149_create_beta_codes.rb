class CreateBetaCodes < ActiveRecord::Migration
  def change
    create_table :beta_codes do |t|
      t.integer :value

      t.timestamps
    end
  end
end
