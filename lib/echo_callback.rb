require_relative 'message'
require_relative 'params'
require 'singleton'

class EchoCallback
  include Singleton
  def initialize
    @m = Message.instance
  end

  def start
    echoString = ""
    speakingString = ""
    @m.echoStringMutex.synchronize{
      echoString = @m.echoString
    }
    @m.speakingStringMutex.synchronize{
      speakingString = @m.speakingString
    }
    if echoString == Params::EndEcho and speakingString != Params::EndSpeaking
      @m.echoStringMutex.synchronize{
        @m.echoString = speakingString
      }
      @m.speakingStringMutex.synchronize{
        @m.speakingString = Params::EndSpeaking
      }
    end
  end
end
