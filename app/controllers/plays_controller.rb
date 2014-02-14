class PlaysController < ApplicationController
  before_action :set_play, only: [:create, :update, :destroy]

	def index
		@plays = Play.all
	end

	def create
		@play.save
	  format.json { head :no_content }
	end

  def update
		@play.count += 1	
  	@play.update(play_params)
    format.json { head :no_content }
	end

  def destroy
    @play.destroy
    respond_to do |format|
      format.html { redirect_to plays_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_play
			attributes = {user_id: current_user.id, track_id: params[:track_id]}
			@play = Play.first_or_initialize(attributes)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def play_params
      params.require(:play).permit(:track_id, :user_id, :count)
    end
end
