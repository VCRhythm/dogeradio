class RanksController < ApplicationController

	def create
		@playlist = current_user.playlists.find(params['playlist_id'])
		@rank = Rank.new(music_id: params['music_id'], playlist_id: params['playlist_id'])
	end

	def destroy
		@playlist = current_user.playlists.find(params[:playlist_id])
	  @playlist.ranks.where("position = ? AND music_id = ?", params[:position], params[:music_id]).first.delete
		@ranks = @playlist.ranks.order(position: :asc)
		i = 1
		@ranks.each do |rank|
			rank.position = i
			rank.save
			i+=1
		end
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
		def ranking_params
		  params.require(:ranking).permit(:rank, :trip_id, :market_id)
	  end
end
