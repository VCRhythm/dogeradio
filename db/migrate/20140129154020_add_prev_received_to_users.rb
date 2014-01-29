class AddPrevReceivedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :prev_received, :float, default: 0.0
  end
end
