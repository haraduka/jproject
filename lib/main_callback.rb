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
      when /踊って|踊りなさい/xi
        shouldEcho = "踊っちゃうよ〜〜"
        @m.servoCommandMutex.synchronize{
          @m.servoCommand = Params::Servo::PP
        }
        @m.motorCommandMutex.synchronize{
          @m.motorCommand = Params::Motor::PP
        }
      when /止まれ|止まって|止まりなさい/xi
        shouldEcho = "はーい。ごめんね。"
        @m.servoCommandMutex.synchronize{
          @m.servoCommand = Params::Servo::DOWN
        }
        @m.motorCommandMutex.synchronize{
          @m.motorCommand = Params::Motor::FREE
        }
      when /楽しいね|嬉しいね|最高だね/xi
        shouldEcho = "ハロも" + text.delete("だね")
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::SMILE
        }
        @m.leftLcdStringMutex.synchronize{
          @m.leftLcdString = Params::LCD::SMILE
        }
      when /疲れたね|死にたい|この世界はつらい/xi
        shouldEcho = "ハロも疲れたよお"
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::TSURAMI
        }
        @m.leftLcdStringMutex.synchronize{
          @m.leftLcdString = Params::LCD::TSURAMI
        }
      when /怒って/xi
        shouldEcho = "ハロ、おこだよ！"
        @m.rightLcdStringMutex.synchronize{
          @m.rightLcdString = Params::LCD::ANGRY
        }
        @m.leftLcdStringMutex.synchronize{
          @m.leftLcdString = Params::LCD::ANGRY
        }
      when /パタパタして|パタパタしなさい/xi
        shouldEcho = "パタパタしますよ"
        @m.servoCommandMutex.synchronize{
          @m.servoCommand = Params::Servo::PP
        }
      when /こんにちは/xi
        shouldEcho = "こんにちわ、ハロです"
      when /元気ですか|元気そうだね/xi
        shouldEcho = "元気いっぱい！"
      when /ハロ/xi
        shouldEcho = "何か御用でしょうか"
      when /おっぱい/xi
        shouldEcho = "私はGカップ未満のおっぱいをおっぱいとは認めません"
      when /自主プロジェクト/xi
        shouldEcho = "めっちゃつらい"
      when /忘年会間近だね/xi
        shouldEcho = "みんな自主プロジェクトお疲れコンパ来てね！今日の七時からだよ！"
      when /クリスマス/xi
        shouldEcho = "今年は寂しいなぁ"
      when /納豆/xi
        shouldEcho = "森かよ"
      when /アルミ缶の上にあるみかん/xi
        shouldEcho = "まよこかよ"
      when /河原塚健人/xi
        shouldEcho = "ぼくを作った人！"
      when /だね$/xi
        mth = text.match(/(.+)だね/)
        shouldEcho = mth[1] + "だよ"
      else
        shouldEcho = text
      end
      if shouldEcho != "" and echoString == Params::EndEcho
        @m.echoStringMutex.synchronize{
          @m.echoString = shouldEcho
        }
      end
    end
  end
end
