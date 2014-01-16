class MusicsController < ApplicationController
	include AWS::S3
  before_action :set_music, only: [:show, :edit, :update, :destroy]

  # GET /musics
  # GET /musics.json
  def index
    @musics = AWS::S3::Bucket.find(BUCKET).objects
  end

  # GET /musics/1
  # GET /musics/1.json
  def show
  end

  # GET /musics/new
  def new
    @music = Music.new
  end

  # GET /musics/1/edit
  def edit
  end

  # POST /musics
  # POST /musics.json
  def create
    @music = Music.new(music_params)
		AWS::S3::S3Object.store(sanitive_filename(params[:mp3file].original_filename), params[:mp3file].read, BUCKET, access: :public_read)
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

	def upload
		begin
			AWS::S3::S3Object.store(sanitize_filename(params[:mp3file].original_filename), params[:mp3file].read, BUCKET, access: :public_read)
			redirect_to root_path
		rescue
			render text: "Couldn't complete the upload"
		end
	end

  # DELETE /musics/1
  # DELETE /musics/1.json
  def delete
    if(params[:song])
			AWS::S3::S3Object.find(params[:song], BUCKET).delete
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
      params.require(:music).permit(:name, :user_id)
    end
end
