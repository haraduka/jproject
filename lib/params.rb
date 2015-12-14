
module Params
  EndSpeaking = "EndSpeaking"
  EndEcho = "EndEcho"
  EndTwitter = "EndTwitter"

  module Mode
    Echo = "echo"
    Main = "main"
    Presen = "presen"
    News = "news"
  end

  module LCD
    DEFAULT = "default"
    KEEP = "keep"
    SMILE = "smilesmilesmile"
    ANGRY = "angryangryangry"
    TSURAMI = "tsuramitsuramitsurami"
  end

  module Motor
    KEEP = "keep"
    PP = "pp"
    GO = "go"
    RIGHT = "right"
    LEFT = "left"
    FREE = "stop"
  end

  module Servo
    PP = "p"
    KEEP = "keep"
    UP = 'u'
    DOWN = 'd'
  end

  module LED
    KEEP = "keep"
    NONE = 'n'
    GREEN = 'g'
    SKYBLUE = 's'
    BLUE = 'b'
    PURPLE = 'p'
    RED = 'r'
    YELLOW = 'y'
    WHITE = 'w'
  end
end
