# == Schema Information
#
# Table name: plays
#
#  id         :integer          not null, primary key
#  count      :integer          default(1)
#  track_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Play < ActiveRecord::Base
  belongs_to :track
  belongs_to :user

	validates :track_id, presence: true
	
	validate :not_already_counted_today?, on: :update

	scope :by_users, -> {where.not(user_id: 0)}

	private
	
	def not_already_counted_today?
		if user_id > 0 && updated_at > 1.day.ago
#			errors.add(:user, "already played this song today")
			false
		else
			true
		end
	end
end
