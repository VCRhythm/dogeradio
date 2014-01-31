class PlaylistsController < ApplicationController
	def sort
		@playlist = Playlist.find(params[:playlist_id])
		@sort_group = params['playlist']
		@ranks = @playlist.ranks
		@ranks.each do |rank|
			rank.position = @sort_group.index(rank.position.to_s)+1 
			rank.save
		end
	end
end
