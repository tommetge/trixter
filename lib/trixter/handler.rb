# This handler, by default, does no more than log
class EventHandler
  def initialize
    @current_event = nil
    @crank_changes = []
  end

  def handleEvent(event)
    # We throw out initial state
    if @current_event == nil
      @current_event = event
      return
    end

    # Process boolean-on events (we only care when they are 'on')
    if event.leftGearUp and not @current_event.leftGearUp
      leftGearUp
    end
    if event.leftGearDown and not @current_event.leftGearDown
      leftGearDown
    end
    if event.rightGearUp and not @current_event.rightGearUp
      rightGearUp
    end
    if event.rightGearDown and not @current_event.rightGearDown
      rightGearDown
    end
    if event.leftControlUp and not @current_event.leftControlUp
      leftControlUp
    end
    if event.leftControlDown and not @current_event.leftControlDown
      leftControlDown
    end
    if event.leftControlLeft and not @current_event.leftControlLeft
      leftControlLeft
    end
    if event.leftControlRight and not @current_event.leftControlRight
      leftControlRight
    end
    if event.rightControlLeft and not @current_event.rightControlLeft
      rightControlLeft
    end
    if event.rightControlRight and not @current_event.rightControlRight
      rightControlRight
    end
    if event.rightControlUp and not @current_event.rightControlUp
      rightControlUp
    end

    # Process scaled events
    if event.leftBrakePressure != @current_event.leftBrakePressure
      leftBrakeChanged(event.leftBrakePressure)
    end
    if event.rightBrakePressure != @current_event.rightBrakePressure
      rightBrakeChanged(event.rightBrakePressure)
    end
    if event.crankPosition != @current_event.crankPosition
      crankPositionChanged(event)
    end

    # Seated or not
    if event.seated != @current_event.seated
      seatingChanged(event.seated)
    end

    @current_event = event
  end

  def seatingChanged(seated)
    if seated
      puts "Rider is seated"
    else
      puts "Rider is standing"
    end
  end

  def crankPositionChanged(event)
    if @last_crank_change == nil
      @last_crank_change = event.time
      return
    end

    forward = false
    ticks = 0
    past_position = @current_event.crankPosition.hex
    current_position = event.crankPosition.hex
    if past_position < current_position
      ticks = current_position - past_position
      if ticks < 30
        forward = true
      else
        ticks = 60 - ticks
      end
    else
      ticks = past_position - current_position
      if ticks > 30
        ticks = 60 - ticks
        forward = true
      end
    end

    change = CrankChange.new(ticks, event.time, event.time - @last_crank_change)
    @crank_changes << change
    to_delete = []
    while (event.time - @crank_changes.first.time) > 0.4
      @crank_changes.delete_at(0)
    end

    smoothed_ticks = 0
    for change in @crank_changes
      smoothed_ticks += change.ticks
    end

    first_change = @crank_changes.first

    if event.time - first_change.time == 0
      crankSpeedChanged(0)
    else
      rpms = (smoothed_ticks/60.0) * (60.0/(event.time - first_change.time))
      crankSpeedChanged(rpms)
    end  
    
    @last_crank_change = event.time
  end

  def crankSpeedChanged(rpms)
    puts "Crank RPM: #{rpms}"
  end

  def leftBrakeChanged(strength)
    puts "Left brake engaged at #{strength}"
  end

  def rightBrakeChanged(strength)
    puts "Right brake engaged at #{strength}"
  end

  def leftGearUp
    puts "Left gear up!"
  end

  def leftGearDown
    puts "Left gear down!"
  end

  def rightGearUp
    puts "Right gear up!"
  end

  def rightGearDown
    puts "Right gear down!"
  end

  def leftControlLeft
    puts "Left control left pushed"
  end

  def leftControlRight
    puts "Left control right pushed"
  end

  def leftControlUp
    puts "Left control up pushed"
  end

  def leftControlDown
    puts "Left control down pushed"
  end

  def rightControlLeft
    puts "Right control left pushed"
  end

  def rightControlRight
    puts "Right control right pushed"
  end

  def rightControlUp
    puts "Right control up pushed"
  end
end
