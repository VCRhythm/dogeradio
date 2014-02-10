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

	validates :track_id, uniqueness: { scope: :user_id }, presence: true
	
	validate :not_already_counted_today?, on: :update

	private

	def not_already_counted_today?
		if updated_at > 1.day.ago
			errors.add(:user, "already played this song today")
		end
	end
end
