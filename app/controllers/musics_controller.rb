class MusicsController < ApplicationController
  before_action :set_music, only: [:show, :edit, :update, :destroy]
  before_filter :layout_container, only: [:new]

	# POST /musics
  # POST /musics.json
  def create
    @music = current_user.uploaded_tracks.new(music_params)
		@music.name = params[:filename]
		@music.save
		@track = @music.associated_track
  end

  def new
    choose_layout
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

    def layout_container
      @layout_container = "upload-track"
    end 

    def choose_layout
      respond_to do |format|
        format.html
        format.js { render layout: "events"}
      end 
    end
end
