class SearchController < ApplicationController
	before_action :set_query

	def autocomplete
		results = Track.search @query, index_name: ['tags_index', 'tracks_index', 'users_index'], fields: [:name, :username, :description, :state, :city, :country, :zipcode, :display_name, :city_state], facets: [:state, :city, :country, :zipcode, :city_state], highlight: true, limit:10
		result_names = Array.new()
		results.with_details.each do |result, details|
			case result.class.name
				when "Tag"
					result_names << result.description
				when "Track"
					result_names << result.name
				when "User"
					if result.publish_address
						case details[:highlight].first[0]
							when :city_state
								results_names << result.city_state
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
		end
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
		def search_tracks_by_tag
			matching_tags = Tag.search @query
			@tag_track_results = Array.new() 
			matching_tags.each do |tag|
				@tag_track_results << tag.track
			end
		end

		def search_tags
			results = Tag.search @query, facets: [:description, :category]
			tag_results = Array.new()
			if results.facets["description"]["total"] > 0
				description = results.facets["description"]["terms"][0]["term"]
				results.facets["category"]["terms"].each do |term|
					tag_results << Tag.new(category: term["term"], description: description)
				end
			end
			return tag_results
		end

		def search_users
			User.search(@query, fields: [:username, :display_name], boost: 'followers_count').results + User.search(@query, fields: [:city_state, :city, :state, :zipcode, :country], boost: 'followers_count', where: {publish_address: true}).results
		end

		def search_tracks
			Track.search @query, fields: [:name], boost: 'count_plays'
		end

		def search_params
			params.require(:search).permit(:query, :type)
		end
	
		def set_query
			@query = search_params[:query]  
			@type = search_params[:type]
		end
end
