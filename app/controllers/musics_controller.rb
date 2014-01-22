class MusicsController < ApplicationController
  before_action :set_music, only: [:show, :edit, :update, :destroy]

	# GET /musics
	# GET /musics.json
	def index
		@musics = Music.all
	end

	# POST /musics
  # POST /musics.json
  def create
    @music = current_user.musics.create(music_params)
    respond_to do |format|
      if @music.save
        format.html { redirect_to @music, notice: 'Music was successfully created.' }
        format.json { render action: 'show', status: :created, location: @music }
      else
        format.html { render action: 'new' }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /musics/1
  # PATCH/PUT /musics/1.json
  def update
    respond_to do |format|
      if @music.update(music_params)
        format.html { redirect_to @music, notice: 'Music was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musics/1
  # DELETE /musics/1.json
  def delete
    if(params[:song])
			redirect_to root_path
		else
			render text: 'No song to delete!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
      @music = Music.find(params[:id])
    end

		def sanitize_filename(file_name)
			just_filename = File.basename(file_name)
			just_filename.sub(/[^\w\.\-]/,'_')
		end
		
    # Never trust parameters from the scary internet, only allow the white list through.
    def music_params
      params.require(:music).permit(:name, :user_id, :attachment, :direct_upload_url)
    end
end
