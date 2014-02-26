class VenuesController < ApplicationController
	def new
		@venue = Venue.new
	end
	def create
		@venue = current_user.venues.new(venue_params)
		@venue.save
		redirect_to root_path
	end

	private
    def set_venue
      @venue = Venue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venue_params
      params.require(:venue).permit(:name, :description, :street, :city, :state, :country, :zipcode)
    end
end
