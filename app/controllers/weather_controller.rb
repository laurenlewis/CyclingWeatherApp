class WeatherController < ApplicationController

  def index
  	w_api = Wunderground.new(Rails.application.secrets.wapi_key)
  	@forecast = w_api.forecast_and_conditions_for("19143")
  end

end