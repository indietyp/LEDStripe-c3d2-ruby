require 'socket'
require 'securerandom'
require_relative 'gradient'
class LEDStripe
  def initialize(priority, commando, length)
    @init = []
    @strip = []

    @init << priority
    @init << 0
    @length = [length * 3].pack('n')
  end

  ### send data over UDP ###
  def set(stripArray)
    beamMeUpScottie = UDPSocket.new
    beamMeUpScottie.connect("127.0.0.1", 4913)
    beamMeUpScottie.write @init.pack('C*') + @length + stripArray.pack('C*')
    # p stripArray.count/3
    @strip = []
  end

  ### HEX TO GBR and return ###
  def single(color)
    color = color.match /(..)(..)(..)/
    [color[3].hex, color[2].hex, color[1].hex]
  end

  ### MODULES ###
  ### train modules ###
  def moduleTrain(length, pointer, trainLED, defaultLED)
    pointer.times do
      defaultLED.each { |ledColor|  @strip << ledColor }
    end

    moduleGradientLine trainLED

    (length-(pointer+trainLED.count)).times do
      defaultLED.each {|ledColor| @strip << ledColor}
    end
  end
  def boxTrain(pointer, led, defaultLED)
    moduleTrain 20, pointer, led, defaultLED
  end
  def boxGradientTrain
    ## train in box ==> gradient in circle! wuhu!
  end
  ## HIDE TRAIN IN VOID
  ## wobble ##

  ### solid color module ##
  def moduleSolidColor(length, color)
    length.times do
      single(color).each { |ledColor| @strip << ledColor }
    end
  end

  ### gradient line module ###
  def moduleGradientLine(gradient)
    gradient.each do |color|
      single(color.delete('#')).each { |ledColor| @strip << ledColor }
    end
  end

  ### FUNCTIONS ###
  def gradientLine(box, startColor, endColor)
    moduleSolidColor 20, box
    moduleGradientLine Gradient.new(colors: [ '#' + startColor, '#' + endColor], steps: 103).hex
    moduleGradientLine Gradient.new(colors: [ '#' + endColor, '#' + startColor], steps: 103).hex
    set(@strip)
  end

  def solidColor(color)
    moduleSolidColor 226, color
    set(@strip)
  end

  def seperate(box, left, right)
    moduleSolidColor 20, box
    moduleSolidColor 103, left
    moduleSolidColor 103, right
    set(@strip)
  end

  def train(length, speed, boxColor, trainStartColor, trainEndColor, otherColor, wanderer)
    trainPointer = 0
    boxPointer = 0
    asc = true
    boxLED = single boxColor
    otherLED = single otherColor

    lonelyWanderer = []
    3.times {lonelyWanderer << wanderer}

    loop do
      # asc == true ? trainLED = Gradient.new(colors: ['#' + trainStartColor, '#' + trainEndColor], steps: length) : trainLED = Gradient.new(colors: ['#' + trainEndColor, '#' + trainStartColor], steps: length)

      trainLED = Gradient.new(colors: ['#' + trainStartColor, '#' + trainEndColor], steps: length)

      boxTrain boxPointer, lonelyWanderer, boxLED
      moduleTrain 206, trainPointer, trainLED.hex, otherLED

      trainStartColor, trainEndColor = trainEndColor, trainStartColor if trainPointer == 0 || trainPointer == 206 - length
      asc = true if trainPointer == 0
      asc = false if trainPointer == 206 - length

      lonelyWanderer.fill SecureRandom.hex(3) if trainPointer % 10 == 0

      asc == true ? trainPointer += 1 : trainPointer -= 1

      boxPointer += 1
      boxPointer = 0 if boxPointer == 20 - 3
      set @strip
      sleep speed
    end
  end


  def gradientRandom
    # leftGradient = Gradient.new(colors: ['#' + SecureRandom.hex(3), '#' + SecureRandom.hex(3)], steps: 125)
    #   leftGradient.hex.each do |color|
    #     p color
    #     # solidColor(color)
    #     # sleep 0.5
    # end
  end
  def disco; end
  def wave; end
end
