class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :description

      t.timestamps
    end
  end
end
