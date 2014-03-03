class AddWhenToEvent < ActiveRecord::Migration
  def change
    add_column :events, :moment, :datetime
  end
end
