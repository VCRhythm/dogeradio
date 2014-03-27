class EventsController < ApplicationController
	before_action :set_event, only: [:show, :edit, :update, :destroy]
	before_action :set_venue, only: [:new, :create, :edit, :venue_events]
	before_action :parse_moment, only: [:update, :create]
	before_filter :authenticate_user!, except: [:show, :venue_events, :index]
	before_filter :layout_container, except: [:index]

	def index
		@venues = Venue.local(100, location).with_upcoming_events
		@events = @venues.collect {|venue| venue.events.upcoming}.first
		@layout_container ="events"
		choose_layout
	end

	def show
		choose_layout
	end

	def venue_events
		@events = @venue.events
		render action: 'index'
	end

	def destroy #authenticated
		venue_id = @event.venue_id
		@event.destroy
		redirect_to venue_path(venue_id)
	end

	def new_user #authenticated
		@event = Event.find(params[:event_id])
		@users = User.no_guests.order("display_name ASC")
		choose_layout
	end

	def add_user #authenticated
		@event = Event.find(params[:event_id])
		if @event.creator?(current_user)
			params[:event][:users].each do |user_id|
				user = User.find(user_id)
				if !@event.has_user?(user)
					@event.users << user
				end
			end
		end
		choose_layout
	end

	def edit #authenticated
		choose_layout
	end

	def update #authenticated
    	respond_to do |format|
      		if @event.update(event_params)
        		format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        		format.json { render action: 'show', status: :updated, location: @event }
      		else
        		format.html { render action: 'edit' }
        		format.json { render json: @event.errors, status: :unprocessable_entity }
      		end
    	end
  	end

	def new #authenticated
		@event = Event.new
		if @venue.jambase_id
			@jambase_events = @venue.jambase_events
			respond_to do |format|
				format.html
				format.js { render layout: "jambase_events"}
			end
		else
			choose_layout
		end
	end

	def create #authenticated
		@event = Event.new(event_params)
		@event.venue_id = @venue.id
		current_user.created_events << @event
		respond_to do |format|
			if @event.save
				format.html { redirect_to @venue, notice: 'Event was sucessfully added.' }
				format.json { render action: :show, status: :created, location: @venue }
			else
				format.html { render action: :new }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
	end

	private
   	def layout_container
		@layout_container = "action-panel"
	end

	def choose_layout
		respond_to do |format|
			format.html
			format.js { render layout: "events"}
		end
	end

	def parse_moment
    	params[:event][:moment] = Chronic.parse(params[:event][:moment])
    end

    def set_venue
		@venue = Venue.find(params[:venue_id])
    end

    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :featured, :description, :moment, :users)
    end
end