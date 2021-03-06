# == Schema Information
#
# Table name: ranks
#
#  id          :integer          not null, primary key
#  track_id    :integer
#  playlist_id :integer
#  rank        :integer
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#

class Rank < ActiveRecord::Base
  belongs_to :track
  belongs_to :playlist
	acts_as_list scope: :playlist
end
