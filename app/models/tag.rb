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
	validates :track_id, presence: true
	validates :category, :description, presence: true

	searchkick autocomplete: ['description'], index_name: 'tags_index'
	has_many :votes, dependent: :destroy

	include CI_Find
	include CI_Find_First
	
	scope :unique_tags, -> {select(:category, :description).uniq}
end
