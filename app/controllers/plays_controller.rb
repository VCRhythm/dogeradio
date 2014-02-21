class PlaysController < ApplicationController
  before_action :set_play, only: [:create, :update, :destroy]

	def index
		@plays = Play.all
	end

	def create
		@play.save
		render nothing: true
	end

  def update
		if signed_in?
			@play.count += 1	
			@play.save
		end
		render nothing: true
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
			if signed_in?
				user_id = current_user.id
			else
				user_id = 0
			end
			attributes = {user_id: user_id, track_id: params[:track_id]}
			@play = Play.first_or_initialize(attributes)
    end

end
