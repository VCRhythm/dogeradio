class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :name
      t.belongs_to :user, index: true, null: false
			t.string :direct_upload_url, null: false
			t.attachment :upload
			t.boolean :processed, default: false, null: false

      t.timestamps
    end
		add_index :musics, :processed
  end
end
