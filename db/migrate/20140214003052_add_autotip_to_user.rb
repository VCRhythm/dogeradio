class AddAutotipToUser < ActiveRecord::Migration
  def change
    add_column :users, :autotip, :boolean, default: false
  end
end
