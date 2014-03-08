class AddAvatarColumnToVenues < ActiveRecord::Migration
  def change
		add_attachment :venues, :avatar
  end
end
