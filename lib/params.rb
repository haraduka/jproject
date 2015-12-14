
module Params
  EndSpeaking = "EndSpeaking"
  EndEcho = "EndEcho"
  EndTwitter = "EndTwitter"

  module LCD
    DEFAULT = "default"
    KEEP = "keep"
    SMILE = "smile"
    ANGRY = "angry"
  end

  module Motor
    KEEP = "keep"
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
