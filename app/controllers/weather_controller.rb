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
	  options = ["CO/Denver", "IL/Chicago"]
	  options.sample
	end

  # Main Algorithm:
  # Get the recommendation based on the current weather
  def get_recommendation(weather)
    @all_items = User.find(current_user.id).items
    @items =[] # Initialize array for recommended items

    @all_items.each do |item|
      if weather["current_temp"] < 45
        if item.typeofweather == 'Very Cold'
          @items.push(item)
        end
      end
    end
    # if weather["current_temp"] < 60 && weather["current_temp"] >= 50
    #   @recommendation = "Still mild weather, add a jacket."
    #   @items.push("REI Jacket")
    # elsif weather["current_temp"] < 50 && weather["current_temp"] >= 40
    #   @recommendation = "Getting cold, add at least two torso layers. Gloves and headgear optional."
    #   @items.push("REI Jacket")
    #   @items.push("North Face Fleece")  
    # elsif weather["current_temp"] < 40 && weather["current_temp"] >= 32
    #   @recommendation = "It's almost freezing! Wear multiple layers for torso, make sure to have gloves and headgear."
    #   @items.push("REI Jacket")
    #   @items.push("North Face Fleece") 
    #   @items.push("Gloves")
    #   @items.push("Balaklava")
    # elsif weather["current_temp"] < 32
    #   @recommendation = "Temperature is below freezing. We recommend taking public transportation. If you are riding, wear breathable layers, go slow over ice, and bring plenty of water!"
    #   @items.push("Gloves")
    #   @items.push("Balaklava")
    #   @items.push("Under Armour Leggings")
    # else
    #   @recommendation = "Current temperature is above 60°F. Enjoy biking!"
    #   @items.push("None")
    # end
    
  end
end
