class TagsController < ApplicationController
  before_action :set_tag, only: [:search, :show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:update, :edit, :create, :destroy, :new]
  before_filter :layout_container, only: [:new]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
		@tag = Tag.new
		@track = Track.find(params[:track_id])
		choose_layout
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
		@track = Track.find(params[:track_id])
    @tag = @track.tags.create(tag_params)
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:track_id, :category, :description)
    end

    def layout_container
      @layout_container = "action-panel"
    end 

    def choose_layout
      respond_to do |format|
        format.html
        format.js { render layout: "events"}
      end 
    end
end
