class PlaylistsController < ApplicationController
	def sort
		@playlist = current_user.playlists.find(params[:playlist_id])
		@sort_group = params[:playlist]

		ranks = @playlist.ranks
		ranks.each do |rank|
			rank.position = @sort_group.index(rank.position.to_s)+1 
			rank.save
		end
	end

	private

  def playlist_params
  	params.require(:playlist).permit()
  end
end
