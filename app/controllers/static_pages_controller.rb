class StaticPagesController < ApplicationController
	#skip_before_filter :verify_authenticity_token
	before_filter :layout_container, except: [:contact, :events_sidebar]

	def events_sidebar
		@venues = Venue.local(100, location).with_upcoming_events
		@local_events = @venues.collect {|venue| venue.events}.first
		@local_events = @local_events ? @local_events.order(moment: :asc) : nil
	end

	def contact
		@layout_container = "action-panel"
		choose_layout
	end

	def send_contact
		@email = params[:user][:email]
		@message = params[:message]
		ContactTristan.user_email(@email, @message).deliver
	end

	def main
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
		choose_layout
	end

	def about
		choose_layout
	end

	def test
	end

	def wow
		choose_layout
	end

	def discover
		#@top_most_played_tracks = Track.most_played
		#@tags = Tag.unique_tags
		choose_layout
	end

	def upload
		choose_layout
	end

	private
	def choose_layout
		respond_to do |format|
			format.html
			format.js { render layout: "events"}
		end
	end
	def layout_container
		@layout_container = "main-body"
	end

end
