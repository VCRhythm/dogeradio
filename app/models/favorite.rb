# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  track_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Favorite < ActiveRecord::Base
  belongs_to :track
  belongs_to :user
	validates :track_id, presence: true
	validates :user_id, presence: true
end
