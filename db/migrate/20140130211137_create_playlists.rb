class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
			t.string :name
			t.belongs_to :user
			
      t.timestamps
    end

		create_table :musics_playlists, id: false do |t|
			t.references :playlist
			t.references :music
		end
		add_index :musics_playlists, [:music_id, :playlist_id]
		add_index :musics_playlists, :playlist_id
  end
end
