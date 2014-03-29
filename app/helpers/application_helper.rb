module ApplicationHelper

	def current_user?(user)
		user == current_user
	end

	def my_song?(music)
		music.user == current_user
	end

	def my_event?(event)
		if signed_in?
			event.creators.exists?(id:current_user_or_guest.id)
		end
	end

end
