class SearchController < ApplicationController
	before_action :set_query

	def search
		if @type == 'tag'
			search_tracks_by_tag
		elsif @type == 'all'
			@tag_results = search_tags
			@track_results = search_tracks
			@user_results = search_users
		end
	end

  private
		def search_tags
			Tag.ci_find('description', @query)		
		end

		def search_tracks_by_tag
			matching_tags = search_tags
			@tag_track_results = Array.new() 
			matching_tags.each do |tag|
				@tag_track_results << tag.track
			end
		end

		def search_users
			User.ci_find('username', @query)
		end

		def search_tracks
			Music.ci_find('name', @query)
		end

		def search_params
			params.require(:search).permit(:query, :type)
		end
	
		def set_query
			@query = search_params[:query]  
			@type = search_params[:type]
		end
end
