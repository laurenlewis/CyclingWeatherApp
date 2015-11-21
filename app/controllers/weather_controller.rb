class WeatherController < ApplicationController

  def index
  	w_api = Wunderground.new("b559451ca25b9914")
  	@forecast = w_api.forecast_and_conditions_for("19143")
  end

end