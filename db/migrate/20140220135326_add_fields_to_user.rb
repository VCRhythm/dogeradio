class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :display_name, :string
    add_column :users, :address, :string
    add_column :users, :street, :string
    add_column :users, :city, :string
		add_column :users, :state, :string
    add_column :users, :zipcode, :string
    add_column :users, :country, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
		add_column :users, :publish_address, :boolean, default: false
  end

end
