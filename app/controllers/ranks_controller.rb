class RanksController < ApplicationController

	def create
		@music = Music.find(params[:music_id])
		@playlist = current_user.playlists.find(params['playlist_id'])
		@rank = Rank.new(music_id: @music.id, playlist_id: @playlist.id)
		@rank.save
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
