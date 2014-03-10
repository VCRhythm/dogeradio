Yelp.configure(consumer_key: Rails.configuration.apis[:yelp_consumer_key],
			   consumer_secret: Rails.configuration.apis[:yelp_consumer_secret],
			   token: Rails.configuration.apis[:yelp_token],
			   token_secret: Rails.configuration.apis[:yelp_token_secret]
)