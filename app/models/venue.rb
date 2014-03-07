# == Schema Information
#
# Table name: venues
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  street      :string(255)
#  city        :string(255)
#  state       :string(255)
#  country     :string(255)
#  zipcode     :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  lat         :float
#  lng         :float
#  gmaps       :boolean
#

class Venue < ActiveRecord::Base
	has_many :events
	belongs_to :user

	geocoded_by :address, latitude: :lat, longitude: :lng
	after_validation :geocode,
		if: lambda { |obj| obj.street_changed? || obj.city_changed? || obj.state_changed? || obj.country_changed? || obj.zipcode_changed? }

	acts_as_mappable

	scope :with_upcoming_events, -> {joins(:events).merge(Event.upcoming)}

	def self.local(distance, origin)
		within(distance, origin: origin).order('distance DESC')
	end

	def address
		"#{street}, #{state} #{zipcode}, #{country}"
	end

	def gmaps4rails_address
		address
	end
end
