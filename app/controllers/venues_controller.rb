class VenuesController < ApplicationController
	before_action :set_venue, only: [:show, :edit, :update, :destroy, :sync_jambase_ids]
	include Yelp::V2::Search::Request

  	def index
		@venues = Venue.all
	end

	def new
		client = Yelp::Client.new
		request = Location.new(
			term: "concerts",
			city: location.city)
		@yelp_response = client.search(request)["businesses"]
		@venue = Venue.new
	end
	
	def edit
	end
	
	def update
    	respond_to do |format|
      		if @venue.update(venue_params)
        		format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        		format.json { render action: 'show', status: :updated, location: @venue }
      		else
        		format.html { render action: 'edit' }
        		format.json { render json: @venue.errors, status: :unprocessable_entity }
      		end
    	end
  	end

	def local_venues
		@venues = Venue.local(100, location).includes(:events)
	end

	def create
		@venue = current_user.venues.new(venue_params)
		if params[:yelp_image]
			@venue.picture_from_url(params[:yelp_image])
		end
		@venue.jambase_id = @venue.sync_jambase_id
		respond_to do |format|
			if @venue.save
				format.html { redirect_to @venue, notice: 'Venue was sucessfully created.' }
				format.json { render action: 'show', status: :created, location: @venue }
			else
				format.html { render action: 'new' }
				format.json { render json: @venue.errors, status: :unprocessable_entity }
			end
		end
	end

	def show
		@hash = Gmaps4rails.build_markers(@venue) do |venue, marker|
			marker.lat venue.lat
			marker.lng venue.lng
		end
		@upcoming_events = @venue.events.upcoming
		@archived_events = @venue.events.archived
	end

	private
    def set_venue
      @venue = Venue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venue_params
      params.require(:venue).permit(:avatar, :name, :description, :street, :city, :state, :country, :zipcode)
    end
end
