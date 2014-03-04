class AddDistanceToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :distance, :float
  end
end
