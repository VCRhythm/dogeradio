class RanksController < ApplicationController

	def create
		@track = Track.find(params[:track_id])
		@rank = Rank.new(track_id: @track.id, playlist_id: @playlist.id)
		@rank.save
		@rank.move_to_bottom
	end

	def destroy
	  @rank = @playlist.ranks.where("position = ? AND track_id = ?", params[:position], params[:track_id]).first
		@rank.remove_from_list
		@rank.delete
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
		def rank_params
		  params.require(:rank).permit(:position, :track_id)
	  end
end
