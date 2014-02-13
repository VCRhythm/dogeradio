class AddCategoryToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :category, :string, default: "playlist"
  end
end
