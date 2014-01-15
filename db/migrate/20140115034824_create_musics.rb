class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :name
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
