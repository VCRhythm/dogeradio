# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  music_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Favorite < ActiveRecord::Base
  belongs_to :music
  belongs_to :user
	validates :music_id, presence: true
	validates :user_id, presence: true
end
