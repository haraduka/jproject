require 'singleton'
require 'json'
require 'net/http'

class NetAPI
  include Singleton

  # format : [speakmessage, lcdstring]
  def getWeatherTokyo
    uri = URI('http://weather.livedoor.com/forecast/webservice/json/v1?city=130010')
    weather_data = JSON.parse(Net::HTTP.get(uri))
    today_forecast = weather_data['forecasts'][0]
    tomorrow_forecast = weather_data['forecasts'][1]
    forecast_message = "#{tomorrow_forecast['dateLabel']}の天気は#{tomorrow_forecast['telop']}です。" \
      "最高気温は#{tomorrow_forecast['temperature']['max']['celsius']}度、" \
      "最低気温は#{tomorrow_forecast['temperature']['min']['celsius']}度です。"

    uri = URI("http://api.openweathermap.org/data/2.5/weather?q=\"Tokyo\",\"Japan\"&appid=#{ENV['OPENWEATHERMAP_APPID']}")
    weather = JSON.parse(Net::HTTP.get(uri))
    weather_string =  weather['weather'][0]['main'][0, 16].ljust(16, " ")
    weather_string +=  "min: #{ (weather['main']['temp_min'] - 273.15).to_i }"
    weather_string +=  " max: #{ (weather['main']['temp_max'] - 273.15).to_i }"

    return [forecast_message, weather_string]
  end

end
