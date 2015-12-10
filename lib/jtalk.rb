require_relative 'message'
require_relative 'params'
require 'singleton'

class Jtalk
  include Singleton

  def initialize
    @m = Message.instance
  end

  def start
    loop do
      echoString = ""
      @m.echoStringMutex.synchronize{
        echoString = @m.echoString
      }
      if echoString != Params::EndEcho
        system(
          "`echo $JPROJECT_ROOT`/script/jsay.sh #{echoString}"
        )
        sleep 3
        @m.echoStringMutex.synchronize{
          @m.echoString = Params::EndEcho
        }
      end

      isFinished = false
      @m.isFinishedMutex.synchronize{
        isFinished = true if @m.isFinished
      }
      return if isFinished
      sleep 0.1
    end
  end

end
