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
#  when        :datetime
#

class Event < ActiveRecord::Base
	belongs_to :user
	belongs_to :venue
	has_many :tags
	default_scope { order(when: :desc)}

	validates :name, :when, :user_id, :venue_id, presence: true


end
