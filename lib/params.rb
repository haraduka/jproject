
module Params
  EndSpeaking = "EndSpeaking"
  EndEcho = "EndEcho"

  module LCD
    DEFAULT = "default"
    KEEP = "keep"
    SMILE = "smile"
    ANGRY = "angry"
  end

  module Motor
    KEEP = "keep"
    GO = "g"
    RIGHT = "r"
    LEFT = "l"
    FREE = "f"
  end

  module Servo
    KEEP = "keep"
    UP = "\x00"
    DOWN = "\xFF"
  end

  module LED
    KEEP = "keep"
    NONE = 0
    GREEN = 1
    SKYBLUE = 2
    BLUE = 3
    PURPLE = 4
    RED = 5
    YELLOW = 6
    WHITE = 7
  end
end
