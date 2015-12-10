require 'opencv'
require 'singleton'
require_relative 'message'

class DetectFace
  include Singleton

  def initialize
    @window = OpenCV::GUI::Window.new "face detect"
    @capture = OpenCV::CvCapture.open
    @detector = OpenCV::CvHaarClassifierCascade::load "/usr/share/opencv/haarcascades/haarcascade_frontalface_alt.xml"
    @m = Message.instance
    @isDisplay = true
  end

  def init(isDisplay = false)
    @isDisplay = isDisplay
  end

  def start
    loop do
      image = @capture.query
      image = image.resize OpenCV::CvSize.new 160, 120
      maxValue = 0;

      detectored = @detector.detect_objects(image)
      index = -1
      maxValue = 0;
      detectored.each_with_index do |rect, i|
        s = (rect.bottom_right.x - rect.top_left.x) * (rect.bottom_right.y-rect.top_left.y)
        if s > maxValue
          maxValue = s
          index = i
        end
      end
      if index != -1
        tl = detectored[index].top_left
        br = detectored[index].bottom_right
        image.rectangle!(tl, br, :color => OpenCV::CvColor::Red) if @isDisplay
        @m.facePointMutex.synchronize{
          facePoint = [(tl.x + br.x)/2, (tl.y + br.y)/2]
        }
      end
      @window.show image if @isDisplay
      if OpenCV::GUI::wait_key(100)
        @m.isFinishedMutex.synchronize{
          @m.isFinished = true
        }
        return
      end
      isFinished = false
      @m.isFinishedMutex.synchronize{
        isFinished = @m.isFinished
      }
      return if isFinished
      sleep 0.1
    end
  end

end
