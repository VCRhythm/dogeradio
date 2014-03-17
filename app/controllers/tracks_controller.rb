class TracksController < ApplicationController
  	before_action :set_track, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!, only: [:update, :edit, :create, :destroy]

	def update_location
		@local_users = User.local(100, location)
		@venues = Venue.local(100, location).with_upcoming_events
		@local_events = @venues.collect {|venue| venue.events}.first
	end

	def top_tracks
		@top_most_played_tracks = Track.most_played
	end

	def update_player
    	@track = Track.find(params[:track_id])
		@player_position = params[:position]
	end

	def index
		@tracks = Track.order(created_at: :desc)
	end

	def create
    	@track = current_user.tracks.new(track_params)
		@track.save
  	end

	def show
	end

	def edit
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
  	end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params.require(:track).permit(:name, :user_id, :url, :source)
    end

end
