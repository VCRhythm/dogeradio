class StaticPagesController < ApplicationController
	#skip_before_filter :verify_authenticity_token
	helper_method :current_or_guest_user
	
	def main
		@venues = Venue.local(100, location).with_upcoming_events
		@local_events = @venues.collect {|venue| venue.events}.first
		@local_events = @local_events ? @local_events.order(moment: :asc) : nil
		
#		@new_tracks = Music.order(created_at: :desc).where(processed: true).limit(5)
#		@active_users = Array.new

		#Determine "active users"
#		User.all.each do |user|
#			if user.musics.exists?
#				if ((1.week.ago)..(DateTime.now)).cover?(user.musics.last.created_at)
#					@active_users << user
#				end
#			end
#		end
		
		#Local Users
#		@local_users = User.local(100, location)

		#Random Featured Artist
		@featured_user = User.artists.random_user
	end

	def about
	end

	def test
	end
	def discover
		#@top_most_played_tracks = Track.most_played
		#@tags = Tag.unique_tags
	end

	def upload
	end
end
