# == Schema Information
#
# Table name: tracks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  user_id    :integer
#  source     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Track < ActiveRecord::Base
  belongs_to :user
	has_many :tags, dependent: :destroy
	
	has_many :ranks
	has_many :playlists, through: :ranks
	has_many :plays
	has_many :favoriteds, foreign_key: "track_id",
											 	class_name: "Favorite",
												dependent: :destroy
	has_many :fond_users, through: :favoriteds, source: :user

	scope :most_played, -> { joins(:plays) }

	def count_plays
		Play.where(track_id: :track_id).sum("count")	
	end

	def most_played
		Track.joins(:plays).group(:track_id).sum(:count).sort.reverse.limit(10)
	end
	
end
