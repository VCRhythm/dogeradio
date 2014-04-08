class ChangeTypeInTag < ActiveRecord::Migration
  def change
	rename_column :tags, :type, :what
  end
end
