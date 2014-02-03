# == Schema Information
#
# Table name: ranks
#
#  id          :integer          not null, primary key
#  music_id    :integer
#  playlist_id :integer
#  rank        :integer
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#

class Rank < ActiveRecord::Base
  belongs_to :music
  belongs_to :playlist
	acts_as_list scope: :playlist
end
