class PlaylistsController < ApplicationController
	before_action :set_playlist

	def sort
		@sort_group = params[:playlist]
		ranks = @playlist.ranks
		ranks.each do |rank|
			rank.position = @sort_group.index(rank.position.to_s)+1
			rank.save
		end
	end

	private

	def set_playlist
		@playlist = Playlist.find(params[:playlist_id])
	end
end
