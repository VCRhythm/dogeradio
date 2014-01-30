class Rank < ActiveRecord::Base
  belongs_to :music
  belongs_to :playlist
	acts_as_list scope: :playlist
end
