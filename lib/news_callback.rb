require_relative 'message'
require_relative 'params'
require 'singleton'
require_relative 'net_api.rb'

class NewsCallback
  include Singleton
  def initialize
    @m = Message.instance
  end

  def start
    weather = NetAPI.instance.getWeatherTokyo
    @m.rightLcdStringMutex.synchronize{
      @m.rightLcdString = weather[1]
    }
    #tweet = ""
    #@m.twitterStringMutex.synchronize{
    #  tweet = @m.twitterString
    #}
    #@m.leftLcdStringMutex.synchronize{
    #  @m.leftLcdString = tweet
    #}
    sleep 1.9
  end
end
