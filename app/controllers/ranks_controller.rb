class RanksController < ApplicationController
	before_action :set_playlist

	def create
		@track = Track.find(params[:track_id])
		@rank = Rank.new(track_id: @track.id, playlist_id: @playlist.id)
		@rank.save
		@rank.move_to_bottom
	end

	def destroy
		@position = rank_params[:position]
	  @rank = @playlist.ranks.where("position = ? AND track_id = ?", @position, rank_params[:track_id]).first
		@rank.remove_from_list
		@rank.delete
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
		def rank_params
		  params.require(:rank).permit(:position, :track_id)
	  end

		def set_playlist
			@playlist = Playlist.find(params[:playlist_id])
		end
end
