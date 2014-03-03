class EventsController < ApplicationController
	before_action :set_event, only: [:show, :edit, :update, :destroy]
	before_action :set_venue, only: [:new, :create]
	before_filter :authenticate_user!, only: [:new, :create]
	
	def index
		@venues = Venue.local(location.latitude, location.longitude, 100)
		@events = @venues.collect {|venue| venue.events}.first
	end
	
	def new
		@event = Event.new
	end

	def create
		@event = current_user.events.new(event_params)
		@event.venue_id = @venue.id
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

	def show
	end

	private
    
    def set_venue
		@venue = Venue.find(params[:venue_id])
    end
    
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :featured, :description, :moment)
    end
end