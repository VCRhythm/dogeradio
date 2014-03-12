class StaticPagesController < ApplicationController
	def about
	end

	def discover
		#@top_most_played_tracks = Track.most_played
		#@tags = Tag.unique_tags
	end

	def upload
	end
end
