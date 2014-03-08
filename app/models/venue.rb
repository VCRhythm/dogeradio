# == Schema Information
#
# Table name: venues
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  street              :string(255)
#  city                :string(255)
#  state               :string(255)
#  country             :string(255)
#  zipcode             :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  lat                 :float
#  lng                 :float
#  gmaps               :boolean
#  distance            :float
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

class Venue < ActiveRecord::Base
	has_many :events
	belongs_to :user

	has_attached_file :avatar, 
		styles: {
			tinythumb: '50x50#',
			thumb: '100x100#',
			square: '200x200>',
			medium: '300x300'
		}, 
		convert_options: {
			tinythumb: '-quality 75 -strip',
			thumb: '-quality 75 -strip'
		},
		bucket: 'dogeradio-venue'
	
	validates_attachment_content_type :avatar, content_type: /\Aimage/

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
