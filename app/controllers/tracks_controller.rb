class TracksController < ApplicationController
  before_action :set_track, only: [:update_player, :show, :edit, :update, :destroy]
	before_action :set_queue, only: [:explore, :index]

	def explore
		@top_most_played_tracks = Track.most_played
		@tags = Tag.unique_tags
	end

	def update_player
		@player_position = params[:position]
	end

	def index
		tracks_played_sums = Hash.new
		@most_played_tracks = Array.new
		Track.all.each do |track|
			tracks_played_sums[track.id] = track.plays.sum(:count)
		end
		tracks_played_sums = tracks_played_sums.sort_by {|k,v| v}.reverse
		tracks_played_sums.each do |track|
			@most_played_tracks << Track.find(track[0])
		end	
		@top_most_played_tracks = @most_played_tracks[0..10]
		
#		@new_tracks = Music.order(created_at: :desc).where(processed: true).limit(5)
#		@active_users = Array.new

		#Determine "active users"
#		User.all.each do |user|
#			if user.musics.exists?
#				if ((1.week.ago)..(DateTime.now)).cover?(user.musics.last.created_at)
#					@active_users << user
#				end
#			end
#		end
		
		#Random Featured Artist
		@featured_user = User.random_artist
		@featured_user_tracks = @featured_user.tracks

		#Tell the player to play track 1
		@player_position = 1 #needed for next functionality
		@track = @playlist.tracks[0]
	end

  def create
    @track = current_user.tracks.new(track_params)
		@track.save
  end

	def show
	end

  def update
		respond_to do |format|
			if @track.update(track_params)
				format.html { redirect_to @track, notice: 'Track was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @track.errors, status: :unprocessable_entity }
			end
		end
  end

	def destroy
    @track.destroy
		flash[:notice] = "Track has been deleted."
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
		def set_queue
			@playlist = user_signed_in? ? current_user.queue : Playlist.new.tracks << Track.order(created_at: :desc)
		end

    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:track_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params.require(:track).permit(:name, :user_id, :url, :source)
    end
end