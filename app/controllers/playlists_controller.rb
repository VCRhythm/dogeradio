class PlaylistsController < ApplicationController
	def sort
		@music_id = params[:music_id]
		@playlist = Playlist.find(params[:playlist_id])
		@sort_group = params['playlist']
		@musics = @playlist.musics
		@ranks = @playlist.ranks
		@ranks.each do |rank|
			rank.position = @sort_group.index(rank.music_id.to_s) + 1
			rank.save
		end
	end
end
