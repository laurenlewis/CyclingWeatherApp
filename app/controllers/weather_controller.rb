class WeatherController < ApplicationController
  def index
  	w_api = Wunderground.new(Rails.application.secrets.wapi_key)

  	# If we just want to use the user's current location
  	location = { :geo_ip => remote_ip }

  	# For testing, use a random location
  	# location = random_location

  	@forecast = w_api.forecast_and_conditions_for(location)
  end

	private 
	# Get the IP Address of the User (or, locally, hard-code ours in)
	def remote_ip
	  if request.remote_ip == '127.0.0.1' || request.remote_ip == '::1'
	  	# My Local Machine
	  	'76.124.141.194'
	  else
	  	requests.remote_ip
	  end
	end

	# Get a random location from a list of locations
	def random_location
	  options = ["WA/Spokane", "CA/San Francisco", "FL/Miami", "CO/Denver"]
	  options.sample
	end

end
