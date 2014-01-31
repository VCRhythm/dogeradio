class RanksController < ApplicationController

	def create
		@music = Music.find(params['music_id'])
		@playlist = current_user.playlists.find(params['playlist_id'])
		@rank = Rank.new(music_id: @music.id, playlist_id: @playlist.id)
		@rank.save
		@rank.move_to_bottom
	end

	def destroy
		@playlist = current_user.playlists.find(params[:playlist_id])
	  @rank = @playlist.ranks.where("position = ? AND music_id = ?", params[:position], params[:music_id]).first
		@rank.remove_from_list
		@rank.delete
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
		def rank_params
		  params.require(:rank).permit(:position, :playlist_id, :music_id)
	  end
end
