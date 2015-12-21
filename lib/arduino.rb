require_relative 'message'
require_relative 'params'
require 'singleton'
require 'serialport'

class Arduino
  include Singleton

  def initialize
    @m = Message.instance
    @servoCnt = 0
    @motorCnt = 0
    @sp = nil
    until @sp
      begin
        @sp = SerialPort.new("/dev/ttyACM0", 9600)
      rescue
        STDERR.puts "/dev/ttyACMに接続失敗しました\n再接続を試みます"
        sleep 6
        retry
      end
    end
    STDERR.puts "/dev/ttyACMに接続しました"
  end

  def start
    sleep 5
    loop do
      rightLcdString = ""
      @m.rightLcdStringMutex.synchronize{
        rightLcdString = @m.rightLcdString
      }
      case rightLcdString
      when Params::LCD::KEEP
      when Params::LCD::DEFAULT
        @sp.write("rs" + " "*32)
      when Params::LCD::SMILE
        @sp.write("rm" + " "*32)
      when Params::LCD::ANGRY
        @sp.write("ra" + " "*32)
      when Params::LCD::TSURAMI
        @sp.write("rt" + " "*32)
      when Params::LCD::EMBARRASSED
        @sp.write("re" + " "*32)
      else
        @sp.write("rs")
        @sp.write(rightLcdString[0, 16].ljust(16, " "))
        @sp.write(rightLcdString[16, 16] ? rightLcdString[16, 16].ljust(16, " ") : " "*16)
      end

      leftLcdString = ""
      @m.leftLcdStringMutex.synchronize{
        leftLcdString = @m.leftLcdString
      }
      case leftLcdString
      when Params::LCD::KEEP
      when Params::LCD::DEFAULT
        @sp.write("ls" + " "*32)
      when Params::LCD::SMILE
        @sp.write("lm" + " "*32)
      when Params::LCD::ANGRY
        @sp.write("la" + " "*32)
      when Params::LCD::TSURAMI
        @sp.write("lt" + " "*32)
      when Params::LCD::EMBARRASSED
        @sp.write("le" + " "*32)
      else
        @sp.write("ls")
        @sp.write(leftLcdString[0, 16].ljust(16, " "))
        @sp.write(leftLcdString[16, 16] ? leftLcdString[16, 16].ljust(16, " ") : " "*16)
      end

      motorCommand = ""
      @m.motorCommandMutex.synchronize{
        motorCommand = @m.motorCommand
      }
      case motorCommand
      when Params::Motor::KEEP
      when Params::Motor::PP
        @motorCnt += 1
        if @motorCnt == 20
          @motorCnt = 0
          @m.motorCommandMutex.synchronize{
            @m.motorCommand = Params::Motor::DOWN
          }
        end
        if @motorCnt % 3 == 1
          if @motorCnt % 6 == 1
            @sp.write("mr")
          else
            @sp.write("ml")
          end
        end
      when Params::Motor::FREE
        @motorCnt = 0
        @sp.write("mf")
      when Params::Motor::GO
        @motorCnt = 0
        @sp.write("mg")
      when Params::Motor::RIGHT
        @motorCnt = 0
        @sp.write("mr")
      when Params::Motor::LEFT
        @motorCnt = 0
        @sp.write("ml")
      end

      servoCommand = ""
      @m.servoCommandMutex.synchronize{
        servoCommand = @m.servoCommand
      }
      case servoCommand
      when Params::Servo::KEEP
      when Params::Servo::UP
        @servoCnt = 0
        @sp.write("s#{Params::Servo::UP}")
      when Params::Servo::DOWN
        @servoCnt = 0
        @sp.write("s#{Params::Servo::DOWN}")
      when Params::Servo::PP
        @servoCnt += 1
        if @servoCnt == 20
          @servoCnt = 0
          @m.servoCommandMutex.synchronize{
            @m.servoCommand = Params::Servo::DOWN
          }
        end
        if @servoCnt % 3 == 1
          if @servoCnt % 6 == 1
            @sp.write("s#{Params::Servo::UP}")
          else
            @sp.write("s#{Params::Servo::DOWN}")
          end
        end
      end

      ledCommand = ""
      @m.ledCommandMutex.synchronize{
        ledCommand = @m.ledCommand
      }
      case ledCommand
        when Params::LED::KEEP
        else
          @sp.write("e")
          @sp.write(ledCommand)
      end

      isFinished = false
      @m.isFinishedMutex.synchronize{
        isFinished = @m.isFinished
      }
      return if isFinished
      sleep 0.5
    end
  end

end
