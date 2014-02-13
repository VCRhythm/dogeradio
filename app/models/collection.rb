class Collection < ActiveRecord::Base
  belongs_to :user
	has_many :ranks, dependent: :destroy
	has_many :tracks, through: :ranks
end
