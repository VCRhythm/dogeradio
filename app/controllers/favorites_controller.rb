class FavoritesController < ApplicationController
	before_filter :authenticate_user!
	respond_to :html, :js

	def create
		@music = Music.find(params[:favorite][:music_id])
		current_user.favorite!(@music)
		respond_with @music
	end
	def destroy
		@music = Favorite.find(params[:id]).music
		current_user.unfavorite!(@music)
		respond_with @user
	end
end
