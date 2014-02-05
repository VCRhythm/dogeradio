# == Schema Information
#
# Table name: tags
#
#  id          :integer          not null, primary key
#  music_id    :integer
#  category    :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Tag < ActiveRecord::Base
  belongs_to :music
	validates :music_id, presence: true
	validates :category, :description, presence: true
end
