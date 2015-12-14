require_relative 'message'
require_relative 'params'
require 'singleton'

class PresenCallback
  include Singleton
  def initialize
    @m = Message.instance
  end

  def speak (s)
    @m.echoStringMutex.synchronize{
      @m.echoString = s
    }
  end

  def wait
    loop do
      bl = false
      @m.inputMutex.synchronize{
        bl = @m.input
      }
      break if bl
      sleep 0.1
    end
    @m.inputMutex.synchronize{
      @m.input = false
    }
  end

  def start
    #プレゼンの内容を書きましょう
    wait
    speak("こんにちは。ハロです。今日は自主プロジェクトの発表を見に来てくれてありがとう")
    puts "unko1"
    wait
    puts "unko2"
    speak("それではハロの中身を紹介するよ")
    puts "unko3"


    @m.modeMutex.synchronize{
      @m.mode = Params::Mode::Main
    }
  end
end
