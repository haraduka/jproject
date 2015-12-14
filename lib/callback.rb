require_relative 'message'
require_relative 'params'
require_relative 'main_callback'
require_relative 'echo_callback'
require_relative 'presen_callback'
require_relative 'news_callback'
require 'singleton'

class Callback
  include Singleton
  def initialize
    @m = Message.instance
    @main = MainCallback.instance
    @echo = EchoCallback.instance
    @presen = PresenCallback.instance
    @news = NewsCallback.instance
  end

  def start
    loop do
      mode = ""
      @m.modeMutex.synchronize{
        mode = @m.mode
      }

      case mode
      when Params::Mode::Main
        @main.start
      when Params::Mode::Echo
        @echo.start
      when Params::Mode::Presen
        @presen.start
      when Params::Mode::News
        @news.start
      end

      isFinished = false
      @m.isFinishedMutex.synchronize{
        isFinished = @m.isFinished
      }
      return if isFinished
      sleep 0.1
    end
  end
end
