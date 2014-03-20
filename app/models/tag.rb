# == Schema Information
#
# Table name: tags
#
#  id          :integer          not null, primary key
#  track_id    :integer
#  category    :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Tag < ActiveRecord::Base
  	belongs_to :track
  	belongs_to :venue
	validates :track_id, presence: true
	validates :category, :description, presence: true

	searchkick text_start: ['description'], index_name: 'tags_index'
	has_many :votes, dependent: :destroy

	include CI_Find
	include CI_Find_First
	
	scope :track_tags, -> { where }
	scope :unique_track_tags, -> {select(:category, :description).uniq}
	scope :by_votes, -> { joins(:votes) }

end
