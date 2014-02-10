class PlaysController < ApplicationController
  before_action :set_play, only: [:create, :update, :destroy]

	def create
    respond_to do |format|
			if @play.save
				format.html { redirect_to root_url, notice: 'Play was successfully created.' }
			  format.json { render action: 'show', status: :created, location: @play }
			else
			  format.html { render action: 'new' }
			  format.json { render json: @play.errors, status: :unprocessable_entity }
			end
		end
	end

  def update
		@play.count += 1	
    respond_to do |format|
      if @play.update(play_params)
        format.html { redirect_to @play, notice: 'Play was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @play.errors, status: :unprocessable_entity }
      end
		end
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
			@play = Play.where(attributes).first_or_initialize
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def play_params
      params.require(:play).permit(:track_id, :user_id, :count)
    end
end
