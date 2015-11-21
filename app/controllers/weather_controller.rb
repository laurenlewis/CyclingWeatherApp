class WeatherController < ApplicationController

  def index
  	w_api = Wunderground.new("b559451ca25b9914")
  end

end