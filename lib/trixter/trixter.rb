#!/usr/bin/env ruby

require 'serialport'
require 'trixter/handler'
require 'trixter/difficulties'
require 'trixter/event'

class Trixter < EventHandler
  attr_accessor :current_rpms
  attr_accessor :current_difficulty

  def initialize(port)
    super()

    if (File.exists? port)
      @port = SerialPort.new(port, 115200, 8, 1)
    end

    @status_thread = nil
    @control_thread = nil
    @current_rpms = 0
    @current_difficulty = 0
    @saved_difficulty = 0
    @right_brake = false
    @left_brake = false

    @should_run = false
  end

  def run
    return if @should_run or @status_thread != nil
    return if @should_run or @control_thread != nil
    return if ENV['NOBIKE']
    return if @port == nil

    @should_run = true
    @status_thread = Thread.new do
      status
    end
    @control_thread = Thread.new do
      control
    end
  end

  def stop
    @should_run = false
  end

  def running
    return @should_run
  end

  def rightGearUp
    @current_difficulty += 1
    if @current_difficulty >= Difficulties.size
      @current_difficulty = Difficulties.size - 1
    end
    puts "Increased difficulty to level #{@current_difficulty}"
  end

  def rightGearDown
    @current_difficulty -= 1
    if @current_difficulty < 0
      @current_difficulty = 0
    end
    puts "Decreased difficulty to level #{@current_difficulty}"
  end

  def crankSpeedChanged(rpms)
    @current_rpms = rpms
  end

  def leftBrakeChanged(strength)
    pressure = 240 - strength.hex
    if pressure > 10
      if !@left_brake and !@right_brake
        puts "Left brake engaged"
        @saved_difficulty = @current_difficulty
      end

      @left_brake = true
      applyBrake(pressure)
    else
      if @left_brake
        puts "Left brake disengaged"
        # restore selected difficulty
        @left_brake = false
        if !@right_brake
          @current_difficulty = @saved_difficulty
        end
      end
    end
  end

  def rightBrakeChanged(strength)
    pressure = 240 - strength.hex
    if pressure > 10
      if !@left_brake and !@right_brake
        puts "Right brake engaged"
        @saved_difficulty = @current_difficulty
      end

      @right_brake = true
      applyBrake(pressure)
    else
      if @right_brake
        puts "Right brake disengaged"
        # restore selected difficulty
        @right_brake = false
        if !@left_brake
          @current_difficulty = @saved_difficulty
        end
      end
    end
  end

  def applyBrake(pressure)
    span = Difficulties.size - @saved_difficulty - 1
    units = 100.0/span
    new_difficulty = (pressure/units).to_i + @saved_difficulty
    @current_difficulty = [new_difficulty, Difficulties.size - 1].min
  end

  def setDifficulty(difficulty)
    difficulty = Difficulties.size - 1 if difficulty >= Difficulties.size
    difficulty = 0 if difficulty < 0

    @saved_difficulty = @current_difficulty = difficulty
  end

  def status
    while @should_run
      raw_event = ""
      while true
        if raw_event.size == 0
          # Find the start sequence ('6a')
          while raw_event[0] != '6'
            raw_event = @port.read(1)
          end

          raw_event << @port.read(1)
          if raw_event[0..1] != '6a'
            raw_event = ""
            next
          end
        end

        # We may have an incorrect boundary if the event
        # string has multiple "6a" sequences. If we see
        # multiple start sequences before we hit our fixed
        # length (32 bytes), discard, reset at that new
        # offset, and try to fill our event again.
        while raw_event.size < 32
          if raw_event.scan('6a').count > 1
            # reset and try again
            raw_event = "6a"
            next
          end

          if raw_event.scan('6a').count == 0
            raw_event = ""
            next
          end

          raw_event << @port.read(1)
        end

        break
      end

      handleEvent(Event.new(raw_event))
    end
  end

  def control
    while @should_run
      sleep 0.01
      @port.write([Difficulties[@current_difficulty]].pack("H*"))
    end
  end

  def join
    if @status_thread != nil
      @status_thread.join
    end
    if @control_thread != nil
      @control_thread.join
    end
  end
end
