require 'thread'
require_relative 'lib/message'
require_relative 'lib/detect_face'
require_relative 'lib/jtalk'
require_relative 'lib/julius'
require_relative 'lib/callback'
require_relative 'lib/arduino'

# juliusのmoduleスレッドの開始
threadSystemJulius = Thread.new {
  system(
    'julius -C `echo $JPROJECT_ROOT`/external/julius-kits/dictation-kit-v4.3.1-linux/main.jconf \
    -C `echo $JPROJECT_ROOT`/external/julius-kits/dictation-kit-v4.3.1-linux/am-gmm.jconf \
    -demo -module'
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
  detect.init true
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

