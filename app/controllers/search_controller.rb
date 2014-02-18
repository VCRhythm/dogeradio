class SearchController < ApplicationController
	before_action :set_query

	def autocomplete
		render json: Track.search(@query, autocomplete: true, limit: 10).map(&:name)
	end

	def search
		if @type == 'tag'
			search_tracks_by_tag
		elsif @type == 'all'
			@tag_results = search_tags
			@track_results = search_tracks
			@user_results = search_users
		end
		render 'search.js.erb'
	end

  private
		def search_tags
			Tag.search(@query)
		end

		def search_tracks_by_tag
			matching_tags = search_tags
			@tag_track_results = Array.new() 
			matching_tags.each do |tag|
				@tag_track_results << tag.track
			end
		end

		def search_users
			User.search(@query)		
		end

		def search_tracks
			Track.search(@query)
		end

		def search_params
			params.require(:search).permit(:query, :type)
		end
	
		def set_query
			@query = search_params[:query]  
			@type = search_params[:type]
		end
end
