class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
			t.string :name
			t.belongs_to :user
			
      t.timestamps
    end

		create_table :playlists_tracks, id: false do |t|
			t.references :playlist
			t.references :track
		end
		add_index :playlists_tracks, [:track_id, :playlist_id]
		add_index :playlists_tracks, :playlist_id
  end
end
