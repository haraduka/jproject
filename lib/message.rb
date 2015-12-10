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
  end
end
