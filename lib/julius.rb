require 'socket'
require 'nokogiri'
require 'singleton'
require_relative 'message'
require_relative 'params'


class Julius
  include Singleton
  def initialize
    @m = Message.instance
    @soc = nil
    until @soc
      begin
        @soc = TCPSocket.open("localhost", 10500)
      rescue
        STDERR.puts "Julius に接続失敗しました\n再接続を試みます"
        sleep 6
        retry
      end
    end
    STDERR.puts "Julius に接続しました"
  end

  def start
    source = ''
    while true
      ret = IO.select([@soc])
      ret[0].each do |sock|
        source += sock.recv(65535)
        if /(<RECOGOUT>.*<\/RECOGOUT>)/.match(source.encode("UTF-8", "EUC-JP").gsub(/\n/, ""))
          source = /(<RECOGOUT>.*<\/RECOGOUT>)/.match(source.encode("UTF-8", "EUC-JP").gsub!(/\.\n/, "").gsub(/\n/, ""))[1]
          xml = Nokogiri(source)
          words = (xml/"RECOGOUT"/"SHYPO"/"WHYPO").inject("") {|ws, w| ws + w["WORD"] }
          words.delete!("。")
          unless words == ""
            p words
            echoString = ""
            speakingString = ""
            @m.speakingStringMutex.synchronize{
              speakingString = @m.speakingString
            }
            @m.echoStringMutex.synchronize{
              echoString =  @m.echoString
            }
            if echoString == Params::EndEcho and speakingString == Params::EndSpeaking
              @m.speakingStringMutex.synchronize{
                @m.speakingString = words
              }
            end
          end
          source = ''
        end
      end
      isFinished = false
      @m.isFinishedMutex.synchronize{
        isFinished = @m.isFinished
      }
      return if isFinished
    end
  end

end


