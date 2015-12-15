require 'sinatra'
require 'tilt/erb'
require 'sinatra/reloader'
require_relative 'lib/message'
require_relative 'lib/params'

class Application < Sinatra::Base
  configure :development, :production do
    register Sinatra::Reloader
    set :myaction, [["none", Time.now]]
  end

  get '/' do
    Message.instance.modeMutex.synchronize{
      @mode = Message.instance.mode
    }
    Message.instance.rightLcdStringMutex.synchronize{
      @rightLcdString = Message.instance.rightLcdString
    }
    Message.instance.leftLcdStringMutex.synchronize{
      @leftLcdString = Message.instance.leftLcdString
    }
    Message.instance.motorCommandMutex.synchronize{
      @motorCommand = Message.instance.motorCommand
    }
    Message.instance.servoCommandMutex.synchronize{
      @servoCommand = Message.instance.servoCommand
    }
    case @servoCommand
    when Params::Servo::UP
       @servoCommand = "UP"
    when Params::Servo::DOWN
       @servoCommand = "DOWN"
    when Params::Servo::PP
      @servoCommand = "ﾊﾟﾀﾊﾟﾀ"
    when Params::Servo::KEEP
      @servoCommand = "KEEP"
    end
    Message.instance.ledCommandMutex.synchronize{
      @ledCommand = Message.instance.ledCommand
    }
    case @ledCommand
    when Params::LED::KEEP
      @ledCommand = "KEEP"
    when Params::LED::NONE
      @ledCommand = "NONE"
    when Params::LED::WHITE
      @ledCommand = "WHITE"
    when Params::LED::RED
      @ledCommand = "RED"
    when Params::LED::YELLOW
      @ledCommand = "YELLOW"
    when Params::LED::BLUE
      @ledCommand = "BLUE"
    when Params::LED::PURPLE
      @ledCommand = "PURPLE"
    when Params::LED::GREEN
      @ledCommand = "GREEN"
    when Params::LED::SKYBLUE
      @ledCommand = "SKYBLUE"
    end

    Message.instance.tlmapMutex.synchronize{
      @twitter = Message.instance.tlmap
    }

    while settings.myaction.size > 5
      settings.myaction.shift(1)
    end

    erb :index
  end

  get '/mode/:action' do |a|
    Message.instance.modeMutex.synchronize{
      Message.instance.mode = a;
    }
    settings.myaction.push(["Mode -> #{a}", Time.now])
    redirect '/'
  end

  get '/input' do
    Message.instance.inputMutex.synchronize{
      Message.instance.input = true;
    }
    redirect '/'
  end

  get '/motor/:action' do |a|
    Message.instance.motorCommandMutex.synchronize{
      Message.instance.motorCommand = a;
    }
    settings.myaction.push(["Motor -> #{a}", Time.now])
    redirect '/'
  end

  get '/servo/:action' do |a|
    case a
    when "up"
       @servoCommand = Params::Servo::UP
    when "down"
      @servoCommand = Params::Servo::DOWN
    when "pp"
      @servoCommand = Params::Servo::PP
    end
    Message.instance.servoCommandMutex.synchronize{
      Message.instance.servoCommand = @servoCommand;
    }
    settings.myaction.push(["Servo -> #{a}", Time.now])
    redirect '/'
  end

  get '/led/:action' do |a|
    case a
    when "keep"
      @ledCommand = Params::LED::KEEP
    when "none"
      @ledCommand = Params::LED::NONE
    when "white"
      @ledCommand = Params::LED::WHITE
    when "red"
      @ledCommand = Params::LED::RED
    when "yellow"
      @ledCommand = Params::LED::YELLOW
    when "blue"
      @ledCommand = Params::LED::BLUE
    when "purple"
      @ledCommand = Params::LED::PURPLE
    when "green"
      @ledCommand = Params::LED::GREEN
    when "skyblue"
      @ledCommand = Params::LED::SKYBLUE
    end
    Message.instance.ledCommandMutex.synchronize{
      Message.instance.ledCommand = @ledCommand;
    }
    settings.myaction.push(["LED -> #{a}", Time.now])
    redirect '/'
  end


  post '/rlcd' do
    Message.instance.rightLcdStringMutex.synchronize{
      Message.instance.rightLcdString = @params[:rightLcdString]
    }
    settings.myaction.push(["rigthLCD -> #{@params[:rightLcdString]}", Time.now])
    redirect '/'
  end

  post '/llcd' do
    Message.instance.leftLcdStringMutex.synchronize{
      Message.instance.leftLcdString = @params[:leftLcdString]
    }
    settings.myaction.push(["leftLCD -> #{@params[:leftLcdString]}", Time.now])
    redirect '/'
  end

  post '/echo' do
    Message.instance.echoStringMutex.synchronize{
      Message.instance.echoString = @params[:echoString]
    }
    settings.myaction.push(["echo -> #{@params[:echoString]}", Time.now])
    redirect '/'
  end

  helpers do
  end

end
