#!/usr/bin/env ruby

require 'trixter'
require 'test/unit'

class TestTrixter < Test::Unit::TestCase
  def test_seated
    event = Event.new("6a788032fcfffffffff70000fffe00aa")
    assert(event.seated)
    event = Event.new("6a788032fcffffffffff0000fffe00aa")
    assert(!event.seated)
    event = Event.new("7777777777777777777f777777777777")
    assert(!event.seated)
  end

  def test_crank_position
    event = Event.new("6a788001fcffffffffffc66846010079")
    assert_equal("01", event.crankPosition)
    event = Event.new("6a78803cfcffffffffff0000fffe00aa")
    assert_equal("3c", event.crankPosition)
  end

  def test_gears
    event = Event.new("6a788032fcffffffffff0000fffe00aa")
    assert(!event.leftGearUp)
    assert(!event.leftGearDown)
    assert(!event.rightGearUp)
    assert(!event.rightGearDown)
    event = Event.new("6a788032fcffffff7fdf0000fffe00aa")
    assert(event.leftGearUp)
    assert(!event.leftGearDown)
    assert(event.rightGearUp)
    assert(!event.rightGearDown)
    event = Event.new("6a788032fcffffffffbf0000fffe00aa")
    assert(!event.leftGearUp)
    assert(!event.leftGearDown)
    assert(!event.rightGearUp)
    assert(event.rightGearDown)
    event = Event.new("6a788001fcffffffff7f0000fffe0011")
    assert(!event.leftGearUp)
    assert(event.leftGearDown)
    assert(!event.rightGearUp)
    assert(!event.rightGearDown)
  end

  def test_controls
    event = Event.new("6a788032fcffffffffff0000fffe00aa")
    assert(!event.leftControlLeft)
    assert(!event.leftControlRight)
    assert(!event.leftControlUp)
    assert(!event.leftControlDown)
    assert(!event.rightControlLeft)
    assert(!event.rightControlRight)
    assert(!event.rightControlUp)
    event = Event.new("6a788032fcffffffebff0000fffe00aa")
    assert(event.leftControlLeft)
    assert(!event.leftControlRight)
    assert(!event.leftControlUp)
    assert(event.leftControlDown)
    assert(!event.rightControlLeft)
    assert(!event.rightControlRight)
    assert(!event.rightControlUp)
    event = Event.new("6a788032fcffffffbeff0000fffe00aa")
    assert(!event.leftControlLeft)
    assert(event.leftControlRight)
    assert(event.leftControlUp)
    assert(!event.leftControlDown)
    assert(!event.rightControlLeft)
    assert(!event.rightControlRight)
    assert(!event.rightControlUp)
    event = Event.new("6a788032fcffffffddff0000fffe00aa")
    assert(!event.leftControlLeft)
    assert(!event.leftControlRight)
    assert(!event.leftControlUp)
    assert(!event.leftControlDown)
    assert(event.rightControlLeft)
    assert(!event.rightControlRight)
    assert(event.rightControlUp)
    event = Event.new("6a788032fcfffffff7ff0000fffe00aa")
    assert(!event.leftControlLeft)
    assert(!event.leftControlRight)
    assert(!event.leftControlUp)
    assert(!event.leftControlDown)
    assert(!event.rightControlLeft)
    assert(event.rightControlRight)
    assert(!event.rightControlUp)
  end
end
