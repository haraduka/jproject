require 'sinatra'
require 'erb'
require 'sinatra/reloader'
require_relative 'lib/message'
require_relative 'lib/params'

class Application < Sinatra::Base
  configure :development, :production do
    register Sinatra::Reloader
    set :speakingString, []
  end

  get '/' do
    @speakingString = settings.speakingString
    erb :index
  end

  post '/' do
    settings.speakingString.push(@params[:speakingString])
    @speakingString = settings.speakingString
    Message.instance.echoStringMutex.synchronize{
      Message.instance.echoString = @params[:speakingString]
    }
    erb :index
  end

  helpers do
  end

end
