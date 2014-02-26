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
#

class Venue < ActiveRecord::Base
	has_many :events
	belongs_to :user
end
