class AddPrevReceivedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :prev_received, :float
  end
end
