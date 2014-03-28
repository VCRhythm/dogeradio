module ApplicationHelper

	def current_user?(user)
		user == current_user
	end

	def my_song?(music)
		music.user == current_user
	end

	def my_event?(event)
		event.creators.exists?(id:current_user.id)
	end

end
