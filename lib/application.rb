require 'sinatra'
require 'erb'
require_relative 'message'
require_relative 'params'

class Application < Sinatra::Base
  get '/' do
    @name = ""
    erb :index
  end

  post '/' do
    @name = @params[:name]
    Message.instance.echoStringMutex.synchronize{
      Message.instance.echoString = @name
    }
    erb :index
  end


end
