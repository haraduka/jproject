require_relative 'message'
require_relative 'params'
require 'singleton'

class NewsCallback
  include Singleton
  def initialize
    @m = Message.instance
  end

  def start
  end
end
