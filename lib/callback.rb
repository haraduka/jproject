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

      isFinished = false
      @m.isFinishedMutex.synchronize{
        isFinished = @m.isFinished
      }
      return if isFinished
      sleep(0.1)
    end
  end
end
