module ApplicationHelper

	def location
		if params[:location].blank?
			if Rails.env.test? || Rails.env.development?
				@location ||= Geocoder.search("50.78.167.161").first
			else
				@location ||= request.location
			end
		else
			params[:location].each {|l| l = l.to_i } if params[:location].is_a? Array
			@location ||= Geocoder.search(params[:location]).first
			@location
		end
	end

	def current_user?(user)
		user == current_user
	end

	def my_song?(music)
		music.user == current_user
	end

end
