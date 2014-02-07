class AddNameToBetaCode < ActiveRecord::Migration
  def change
    add_column :beta_codes, :name, :string
  end
end
