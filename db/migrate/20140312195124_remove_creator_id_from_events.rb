class RemoveCreatorIdFromEvents < ActiveRecord::Migration
  def up
		remove_column :events, :creator_id
  end
end
