class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :url
      t.belongs_to :user, index: true
      t.string :source

      t.timestamps
    end
  end
end
