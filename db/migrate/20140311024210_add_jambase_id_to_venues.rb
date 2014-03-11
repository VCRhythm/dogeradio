class AddJambaseIdToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :jambase_id, :integer
  end
end
