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
    @screen_name = @main_client.user.screen_name
  end

  # echoしたものをtweetする
  def tweetStart()
    loop do
      echoString = ""
      @m.echoStringMutex.synchronize{
        echoString = @m.echoString
      }
      if echoString != Params::EndEcho
        @main_client.update echoString
      end
      sleep 1
    end
  end

  def start()
    @streaming_client.user do |object|
      begin
        case object
        when Twitter::Tweet
          text = object.text
          @m.tlmapMutex.synchronize{
            @m.tlmap.push(text)
            while @m.tlmap.size > 5
              @m.tlmap.shift(1)
            end
          }
          if /@#{@screen_name}.+/ === text
            str = /@#{@screen_name}(.+)/.match(text)[1]
            @m.twitterStringMutex.synchronize{
              twitterString = @m.twitterString
              if twitterString == Params::EndTwitter
                @m.twitterString = str
              end
            }
          else
          end
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
    sleep 0.1
  end
end
