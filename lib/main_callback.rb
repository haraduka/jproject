require_relative 'message'
require_relative 'params'
require 'singleton'

class Callback
  include Singleton
  def initialize
    @m = Message.instance
  end

  def start
    loop do
      echoString = ""
      speakingString = ""
      twitterString = ""
      @m.echoStringMutex.synchronize{
        echoString = @m.echoString
      }
      @m.speakingStringMutex.synchronize{
        speakingString = @m.speakingString
        @m.speakingString = Params::EndSpeaking
      }
      @m.twitterStringMutex.synchronize{
        twitterString = @m.twitterString
        @m.twitterString = Params::EndTwitter
      }
      if twitterString != Params::EndTwitter
        speakingString = twitterString
      end
      #echoString == Params::EndEcho //声を発生するときは
      if speakingString != Params::EndSpeaking
        text = speakingString
        text.tr!("０-９Ａ-Ｚａ-ｚ　", "0-9A-Za-z ")
        case text
        when /[踊|おど][れ|り|る|って]/xi
        when /パタパタ|ﾊﾟﾀﾊﾟﾀ/xi
        when /こんにちは|こんにちわ/xi
        when /元気/xi
        when /ハロ/xi
        when /おっぱい/xi
        when /だね$/xi
        end
        @m.echoStringMutex.synchronize{
          @m.echoString = speakingString
        }
      end

      isFinished = false
      @m.isFinishedMutex.synchronize{
        isFinished = @m.isFinished
      }
      return if isFinished
      sleep(0.1)
    end
  end
end
