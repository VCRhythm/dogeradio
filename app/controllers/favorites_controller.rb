class FavoritesController < ApplicationController
	before_filter :authenticate_user!
	respond_to :html, :js

	def create
		@track = Track.find(params[:favorite][:track_id])
		current_user.favorite!(@track)
		respond_with @track
	end
	def destroy
		@track = Favorite.find(params[:id]).track
		current_user.unfavorite!(@track)
		respond_with @user
	end
end
