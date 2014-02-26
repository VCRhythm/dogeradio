# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  featured    :boolean
#  name        :string(255)
#  venue_id    :integer
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Event < ActiveRecord::Base
	belongs_to :user
	has_many :tags
end
