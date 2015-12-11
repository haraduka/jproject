require 'singleton'
require 'thread'
require_relative 'params'

class Message
  include Singleton

  attr_accessor :speakingString, :echoString, :facePoint, :isFinished
  attr_reader :speakingStringMutex, :echoStringMutex, :facePointMutex, :isFinishedMutex

  def initialize
    @speakingString = Params::EndSpeaking
    @speakingStringMutex = Mutex.new
    @echoString = Params::EndEcho
    @echoStringMutex = Mutex.new
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
