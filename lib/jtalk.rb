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
        if ENV['JPROJECT_DEVELOPMENT'] == "true"
          system(
            "`echo $JPROJECT_ROOT`/script/jsay.sh #{echoString}"
          )
        else
          system(
            "`echo $JPROJECT_ROOT`/external/aquestalkpi/AquesTalkPi #{echoString} | aplay"
          )
        end
        sleep 3
        @m.echoStringMutex.synchronize{
          @m.echoString = Params::EndEcho
        }
      end

      isFinished = false
      @m.isFinishedMutex.synchronize{
        isFinished =  @m.isFinished
      }
      return if isFinished
      sleep 0.1
    end
  end

end
