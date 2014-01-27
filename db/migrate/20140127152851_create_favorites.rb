class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.belongs_to :music, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
		add_index :favorites, [:music_id, :user_id], unique:true
  end
end
