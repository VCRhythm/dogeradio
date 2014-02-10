class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.belongs_to :track, index: true
      t.belongs_to :playlist, index: true
      t.integer :rank

      t.timestamps
    end
  end
end
