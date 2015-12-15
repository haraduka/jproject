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


    return [forecast_message, ]
  end

end
