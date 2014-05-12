module ApplicationHelper

	def current_user?(user)
		user == current_user
	end

	def my_song?(music)
		music.user == current_user
	end

	def my_event?(event)
		event.creator?(current_or_guest_user)
	end

end
