class AddSoundcloudAccessTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :soundcloud_access_token, :string
  end
end
