class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.belongs_to :music, index: true
      t.string :category
      t.string :description

      t.timestamps
    end
  end
end
