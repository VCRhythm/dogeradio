class RemoveCreatorIdFromEvents < ActiveRecord::Migration
  def change
		remove_column :events, :creator_id
  end
end
