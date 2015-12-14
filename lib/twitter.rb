require 'twitter'
require 'singleton'
require_relative 'message'
require_relative 'params'

class Streaming
  include Singleton

  def initialize()
    @streaming_client = Twitter::Streaming::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN_KEY']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    @main_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN_KEY']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    @m = Message.instance
  end

  def start()
    @streaming_client.user do |object|
      begin
        case object
        when Twitter::Tweet
          @m.twitterStringMutex.synchronize{
            twitterString = @m.twitterString
            if twitterString == Params::EndTwitter
              @m.twitterString = object.text
            end
          }
          @m.tlmapMutex.synchronize{
            @m.tlmap.push(object.text)
            while @m.tlmap.size > 5
              @m.tlmap.shift(1)
            end
          }
        else
        end
      rescue Twitter::Error::TooManyRequests => e
        # this error happen 5 mins when you send about 5 ~ 10 requests in a few minutes
        p e.rate_limit
        puts e.rate_limit.reset_in
        sleep e.rate_limit.reset_in
        retry
      rescue => e
        p e
        e.backtrace.each do |m|
          puts m
        end
        retry
      end
    end
    isFinished = false
    @m.isFinishedMutex.synchronize{
      isFinished = @m.isFinished
    }
    return if isFinished
    sleep(0.1)
  end
end
