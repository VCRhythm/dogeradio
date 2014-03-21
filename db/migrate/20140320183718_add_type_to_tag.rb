class AddTypeToTag < ActiveRecord::Migration
  def change
    add_column :tags, :type, :string
    rename_column :tags, :track_id, :object_id
  end
end
