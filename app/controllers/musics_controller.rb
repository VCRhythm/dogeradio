class MusicsController < ApplicationController
  before_action :set_music, only: [:show, :edit, :update, :destroy]

	def update_player
		@track = Music.find(params[:music_id])
	end

	# GET /musics
	# GET /musics.json
	def index
		if user_signed_in? 
			@playlist = current_user.playlists.first 
		else
			@playlist = Playlist.new
			@playlist.musics << Music.order(created_at: :desc).where(processed: true)
		end
		tracks_played_sums = Hash.new
		Music.all.each do |music|
			tracks_played_sums[music.id] = music.plays.sum(:count)
		end
		@most_played_tracks = tracks_played_sums.sort_by {|k,v| v}.reverse
		@top_most_played_tracks = @most_played_tracks[0..5]
		@new_tracks = Music.order(created_at: :desc).where(processed: true).limit(5)
		@active_users = Array.new
		User.all.each do |user|
			if user.musics.exists?
				if ((1.week.ago)..(DateTime.now)).cover?(user.musics.last.created_at)
					@active_users << user
				end
			end
		end
		@track = @playlist.musics[0]
	end

	# POST /musics
  # POST /musics.json
  def create
    @music = current_user.musics.new(music_params)
		@music.name = params[:filename]
		@music.save
  end

	# GET /musics/1
	# GET /musics/1.json
	def show
	end

  # PATCH/PUT /musics/1
  # PATCH/PUT /musics/1.json
  def update
    respond_to do |format|
      if @music.update(music_params)
        format.html { redirect_to @music, notice: 'Song was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musics/1
  # DELETE /musics/1.json
	def destroy
    @music.destroy
		flash[:notice] = "Song has been deleted."
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
      @music = Music.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_params
      params.require(:music).permit(:name, :user_id, :upload, :direct_upload_url, :upload_file_name, :processed)
    end
end
