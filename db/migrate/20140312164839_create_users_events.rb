class CreateUsersEvents < ActiveRecord::Migration
  def change
    create_table :users_events do |t|
			t.belongs_to :user
			t.belongs_to :event
    end
  end
end
