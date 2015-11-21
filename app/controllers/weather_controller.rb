class WeatherController < ApplicationController
  def index
  	w_api = Wunderground.new(Rails.application.secrets.wapi_key)

  	# If we just want to use the user's current location
    # location = { :geo_ip => remote_ip }

  	# For testing, use a random location
  	location = random_location

  	@forecast = w_api.forecast_and_conditions_for(location)
  	@todays_forecast = @forecast["forecast"]["simpleforecast"]["forecastday"][0]
    current_weather = @forecast["current_observation"]

    # Create our own hash with just the data we need
  	@my_weather = { 
      "location_display"    => current_weather["display_location"]["full"],
      "current_temp"        => current_weather["temp_f"],
      "current_conditions"  => current_weather["weather"],
      "conditions_image"    => current_weather["icon_url"], 
      "todays_high"         => @todays_forecast["high"]["fahrenheit"],
      "todays_low"          => @todays_forecast["low"]["fahrenheit"]
    }

    get_recommendation(@my_weather)

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
	  options = ["WA/Seattle", "CA/San Francisco", "FL/Miami", "CO/Denver", "IL/Chicago"]
	  options.sample
	end

  # Main Algorithm:
  # Get the recommendation based on the current weather
  def get_recommendation(weather)
    @items = [] # Initialize array for recommended items
    if weather["current_temp"] < 50 && weather["current_temp"] >= 40
      @recommedation = "Getting cold, probably still OK though!"
      @items.push("L.L. Bean Gloves")
      @items.push("Ear muffs")
    elsif weather["current_temp"] < 40
      @recommedation = "It's almost freezing! Take the bus."
      @items.push("None. It's too cold, remember?")
    else
      @recommedation = "Enjoy biking!"
      @items.push("Just yourself.")
    end
    
  end
end
