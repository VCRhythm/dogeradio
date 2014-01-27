module ApplicationHelper

	def current_user?(user)
		user == current_user
	end

	def my_song?(music)
		music.user == current_user
	end

end
