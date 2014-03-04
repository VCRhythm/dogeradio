Geocoder.configure(
	lookup: :bing,
	timeout: 15,
	units: :mi,
	bing: {
		api_key: Rails.configuration.apis[:bing_api]
	}
)