class Favorite < ActiveRecord::Base
  belongs_to :music
  belongs_to :user
	validates :music_id, presence: true
	validates :user_id, presence: true
end
