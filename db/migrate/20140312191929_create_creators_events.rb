class CreateCreatorsEvents < ActiveRecord::Migration
  def change
    create_table :creators_events do |t|
			t.belongs_to :user
			t.belongs_to :event
    end
  end
end
