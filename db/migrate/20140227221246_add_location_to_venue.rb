class AddLocationToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :lat, :float
    add_column :venues, :lng, :float
  end
end
