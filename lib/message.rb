require 'singleton'
require 'thread'
require_relative 'params'

class Message
  include Singleton

  attr_accessor :mode, :input
  attr_reader :modeMutex, :inputMutex

  attr_accessor :speakingString, :echoString, :twitterString, :tlmap, :facePoint, :isFinished
  attr_reader :speakingStringMutex, :echoStringMutex, :twitterStringMutex, :tlmapMutex, :facePointMutex, :isFinishedMutex

  attr_accessor :rightLcdString, :leftLcdString, :motorCommand, :servoCommand, :ledCommand
  attr_reader :rightLcdStringMutex, :leftLcdStringMutex, :motorCommandMutex, :servoCommandMutex, :ledCommandMutex

  def initialize
    @mode = Params::Mode::Main
    @modeMutex = Mutex.new
    @input = false
    @inputMutex = Mutex.new

    @speakingString = Params::EndSpeaking
    @speakingStringMutex = Mutex.new
    @echoString = Params::EndEcho
    @echoStringMutex = Mutex.new
    @twitterString = Params::EndTwitter
    @twitterStringMutex = Mutex.new
    @tlmap = ["none"]
    @tlmapMutex = Mutex.new
    @facePoint = [0, 0]
    @facePointMutex = Mutex.new
    @isFinished = false
    @isFinishedMutex = Mutex.new

    # arduinoに送るもの
    @rightLcdString = Params::LCD::DEFAULT
    @rightLcdStringMutex = Mutex.new
    @leftLcdString = Params::LCD::DEFAULT
    @leftLcdStringMutex = Mutex.new
    @motorCommand = Params::Motor::FREE
    @motorCommandMutex = Mutex.new
    @servoCommand = Params::Servo::DOWN
    @servoCommandMutex = Mutex.new
    @ledCommand = Params::LED::NONE
    @ledCommandMutex = Mutex.new
  end
end
