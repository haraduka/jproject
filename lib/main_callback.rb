require_relative 'message'
require_relative 'params'
require 'singleton'

class MainCallback
  include Singleton
  def initialize
    @m = Message.instance
  end

  def start
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
    if speakingString != Params::EndSpeaking
      text = speakingString
      text.tr!("０-９Ａ-Ｚａ-ｚ　", "0-9A-Za-z ")
      shouldEcho = ""
      case text
      when /踊る|踊れ|踊り|踊ろ|おどる|おどれ|おどり|おどる/xi
        shouldEcho = "踊っちゃうよ〜〜"
        @m.servoCommandMutex.synchronize{
          @m.servoCommand = Params::Servo::PP
        }
        @m.motorCommandMutex.synchronize{
          @m.motorCommand = Params::Motor::PP
        }
      when /楽しい|嬉しい|最高|神/xi
        shouldEcho = "ハロも楽しい！"
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::SMILE
        }
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::SMILE
        }
      when /疲れた|つらい|辛い|死にたい/xi
        shouldEcho = "ハロも疲れたよお"
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::TSURAMI
        }
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::TSURAMI
        }
      when /^はあ|怒/xi
        shouldEcho = "ハロもおこだよ！"
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::ANGRY
        }
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::ANGRY
        }
      when /止まれ|止まって|止まりな/xi
        shouldEcho = "はーい。ごめんね。"
        @m.servoCommandMutex.synchronize{
          @m.servoCommand = Params::Servo::DOWN
        }
        @m.servoCommandMutex.synchronize{
          @m.servoCommand = Params::Servo::DOWN
        }
      when /パタパタ|ぱたぱた/xi
        shouldEcho = "パタパタしますよ"
        @m.servoCommandMutex.synchronize{
          @m.servoCommand = Params::Servo::PP
        }
      when /こんにちは/xi
        shouldEcho = "こんにちわ"
      when /元気/xi
        shouldEcho = "元気です"
      when /ハロ/xi
        shouldEcho = "何か御用でしょうか"
      when /おっぱい/xi
        shouldEcho = "私はGカップ未満のおっぱいをおっぱいとは認めません"
      when /だね$/xi
        mth = text.match(/(.+)だね/)
        shouldEcho = mth[1] + "だよ"
      end
      if shouldEcho != "" and echoString == Params::EndEcho
        @m.echoStringMutex.synchronize{
          @m.echoString = shouldEcho
        }
      end
    end
  end
end
