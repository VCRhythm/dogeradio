class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.belongs_to :track, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
		add_index :favorites, [:track_id, :user_id], unique:true
  end
end
