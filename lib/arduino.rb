require_relative 'message'
require_relative 'params'
require 'singleton'
require 'serialport'

class Arduino
  include Singleton

  def initialize
    @m = Message.instance
    @sp = nil
    until @sp
      begin
        @sp = SerialPort.new("/dev/ttyACM0", 9600)
      rescue
        STDERR.puts "/dev/ttyACM0 に接続失敗しました\n再接続を試みます"
        sleep 6
        retry
      end
    end
    STDERR.puts "/dev/ttyACM0 に接続しました"
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
      when Params::Motor::FREE
        @sp.write("mf")
      when Params::Motor::GO
        @sp.write("mg")
      when Params::Motor::RIGHT
        @sp.write("mr")
      when Params::Motor::LEFT
        @sp.write("ml")
      end
      servoCommand = ""
      @m.servoCommandMutex.synchronize{
        servoCommand = @m.servoCommand
      }
      case servoCommand
      when Params::Servo::KEEP
      when Params::Servo::UP
        @sp.write("s#{Params::Servo::UP}")
      when Params::Servo::DOWN
        @sp.write("s#{Params::Servo::DOWN}")
      when Params::Servo::PP
        @sp.write("s#{Params::Servo::PP}")
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
      sleep 1
    end
  end

end
