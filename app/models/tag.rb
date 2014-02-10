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

	include CI_Find
	include CI_Find_First

end
