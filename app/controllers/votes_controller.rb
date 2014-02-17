class VotesController < ApplicationController
	before_filter :authenticate_user!

	def create
		@tag = Tag.find(params[:tag_id])
		current_user.vote_up!(@tag)
	end

	def destroy
		@tag = Tag.find(params[:id])
		current_user.vote_down!(@tag)
	end
end
