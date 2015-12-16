require 'thread'
require_relative 'lib/message'
require_relative 'lib/detect_face'
require_relative 'lib/jtalk'
require_relative 'lib/julius'
require_relative 'lib/callback'
require_relative 'lib/arduino'
require_relative 'lib/twitter'

# juliusのmoduleスレッドの開始
threadSystemJulius = Thread.new {
  system(
    'julius -C `echo $JPROJECT_ROOT`/script/word.jconf'
  )
}
puts "# systemJulius initialized"

# jtalkのスレッド開始
threadJtalk = Thread.new {
  jtalk = Jtalk.instance
  jtalk.start
}
puts "# jtalk initialized"

# julisuのスレッド開始
threadJulius = Thread.new {
  julius = Julius.instance
  julius.start
}
puts "# julius initialized"

# detectFaceのスレッド開始
threadDetectFace = Thread.new{
  detect = DetectFace.instance
  if ENV['JPROJECT_DEVELOPMENT'] == "true"
    detect.init true
  else
    detect.init false
  end
  detect.start
}
puts "# detectFace initialized"

# mainCallbackのスレッド開始
threadCallback = Thread.new{
  callback = Callback.instance
  callback.start
}
puts "# callback initialized"

# arduinoのスレッド開始
threadArduino = Thread.new{
  arduino = Arduino.instance
  arduino.start
}
puts "# arduino initialized"

#twitterのスレッド開始
threadTwitter = Thread.new{
  twitter = Streaming.instance
  twitter.start
}
puts "# twitter initialized"
