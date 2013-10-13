require 'time'

class Event
  attr_reader :time

  def initialize(bytes)
    @bytes = bytes
    @time = Time.now.to_f
  end

  def crankPosition
    return @bytes[6..7]
  end

  def rightBrakePressure
    return @bytes[8..9]
  end

  def leftBrakePressure
    return @bytes[10..11]
  end

  def leftGearUp
    return @bytes[16] == '7'
  end

  def leftGearDown
    return @bytes[18] == '7'
  end

  def leftControlLeft
    return @bytes[16] == 'e'
  end

  def leftControlRight
    return @bytes[16] == 'b'
  end

  def leftControlDown
    return @bytes[17] == 'b'
  end

  def leftControlUp
    return @bytes[17] == 'e'
  end

  def rightControlLeft
    return @bytes[17] == 'd'
  end

  def rightControlRight
    return @bytes[17] == '7'
  end

  def rightControlUp
    return @bytes[16] == 'd'
  end

  def rightGearUp
    return @bytes[18] == 'd'
  end
  
  def rightGearDown
    return @bytes[18] == 'b'
  end

  def seated
    return @bytes[19] == '7'
  end

  def flywheelRotationTime
    return @bytes[24..27]
  end
end

class CrankChange
  attr_accessor :ticks, :time, :elapsed
  def initialize(ticks, time, elapsed)
    @ticks = ticks
    @time = time
    @elapsed = elapsed
  end
end
