class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.integer :count, default: 1
      t.belongs_to :music, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
