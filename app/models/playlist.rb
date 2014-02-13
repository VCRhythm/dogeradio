# == Schema Information
#
# Table name: playlists
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  category   :string(255)      default("playlist")
#

class Playlist < ActiveRecord::Base
	belongs_to :user
	has_many :ranks, -> {order("position ASC")}
	has_many :tracks, through: :ranks

end
