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

  def pp (b = false)
    @m.servoCommandMutex.synchronize{
      @m.servoCommand = Params::Servo::PP
    }
    if b
      @m.motorCommandMutex.synchronize{
        @m.motorCommand = Params::Motor::PP
      }
    end
  end

  def display (s)
    @m.rightLcdStringMutex.synchronize{
      @m.rightLcdString = s
    }
    @m.leftLcdStringMutex.synchronize{
      @m.leftLcdString = s
    }
  end

  def start
    #プレゼンの内容を書きましょう
    wait
    pp false
    speak "こんにちは。ハロです。今日は自主プロジェクトの発表を見に来てくれてありがとう"
    display "Hello!          My Introduction!"
    wait
    speak "それではハロの中身を紹介するよ"
    wait
    speak "ご清聴、ありがとうございました"
    pp true
    wait

    @m.modeMutex.synchronize{
      @m.mode = Params::Mode::Main
    }
  end
end
