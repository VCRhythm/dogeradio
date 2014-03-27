# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  featured    :boolean
#  name        :string(255)
#  venue_id    :integer
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  moment      :datetime
#

class Event < ActiveRecord::Base
	has_and_belongs_to_many :creators, class_name: "User", join_table: "creators_events", association_foreign_key: :user_id
	has_and_belongs_to_many :users, join_table: "users_events"
	belongs_to :venue
	has_many :tags, foreign_key: :object_id, dependent: :destroy

	scope :upcoming, -> {where("moment >= ?", Time.zone.now)}
	scope :archived, -> {where("moment < ?", Time.zone.now)}
	validates :name, :moment, :venue_id, presence: true

	def creator?(user)
		self.creators.find_by id: user.id
	end

	def has_user?(user)
		self.users.find_by id: user.id
	end

end
