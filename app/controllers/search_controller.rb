class SearchController < ApplicationController
	before_action :set_query

	def autocomplete
		#Search Tracks
		results = Track.search @query, index_name: ['tags_index', 'tracks_index', 'users_index'], fields: [:name, :username, :description, :state, :city, :country, :zipcode, :display_name], highlight: true, limit:10
		result_names = Array.new()
		results.with_details.each do |result, details|
			case result.class.name
				when "Tag"
					result_names << result.description
				when "Track"
					result_names << result.name
				when "User"
					case details[:highlight].first[0]
						when :state
							result_names << result.state	
						when :city
							result_names << result.city
						when :country
							result_names << result.country
						when :zipcode
							result_names << result.zipcode
						when :display_name
							result_names << result.display_name
						when :username
							result_names << result.username
					end
			end
		end
		#Search Tags
		#Search Users
		render json: result_names
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
