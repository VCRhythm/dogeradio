class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :user
      t.boolean :featured
      t.string :name
      t.belongs_to :venue
      t.string :description

      t.timestamps
    end
  end
end
