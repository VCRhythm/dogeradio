class Playlist < ActiveRecord::Base
	belongs_to :user
	has_many :ranks, -> {order("position ASC")}
	has_many :musics, through: :ranks
end
