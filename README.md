# Trixter

If you're lucky enough to have (or can get) a Trixter Dream Bike,
you either are or will be frustrated with the stock software -
especially if you're a serious cyclist. It is for you that this
library is written.

Trixter (the gem) allows you to read the controls, crank speed,
and other hardware states from the Trixter bike itself. It will
also allow you to control the difficulty (the resistance applied
to the flywheel).

Trixter comes with the `trixter` executable which does all of
of the above and provides you with a simple platform with which
you can do drills, spinning, and other things that will help
you be a better cyclist.

## Usage

You will need to remove the back cover (the cover closest to the
rider or seat post) and unplug the black USB cable from the DELL
computer. This USB cable connects all of the actual cycling
hardware. It is actually a Serial to USB converter cable (PL2303)
or compatible. You'll need to install the drivers for this, which
you can obtain here:

http://prolificusa.com/pl-2303hx-drivers/

This gem is tested on Mac OS X 10.8 and 10.9, but it should work
on all platforms for which ruby, the ruby serial library, and the
pl-2303 drivers are available.

Once the drivers are installed, install the gem, plug the Dream
Bike's USB cable into your computer, and run the `trixter`
executable:

```
gem install trixter
trixter
```

Without any customization, the trixter executable allows you to
use the right gear buttons to increase and decrease resistance
and will apply graded resistance when you hit the brakes. It is
a terminal program, so any output is written to the console.

If you would like to do more (like report the RPM, estimate
power, or create "tracks" or fitness programs), it's easy to
modify or subclass the trixter binary. Take a look at
'trixter/trixter.rb' in the gem's lib folder - or just give me
a few weeks and I'll have a new update.

Of course, you're welcome to file an issue with any ideas or
requests. I'd love to hear your ideas. Pull requests are even
more welcome.

## Background

A friend lent me his Dream Bike a couple of years back, knowing
that I was a pretty serious cyclist. I found the platform
exceedingly frustrating, most because of the mandatory levels
(you have to start at 1 and work your way up, regardless of your
actual fitness level). It didn't take long to find the user XML
file, in which I could simply write my own level. Unfortunately,
there are other difficulties:

* Shifting gears was a nightmare. The game shifts up and down
  without your permission whenever your RPMS pass certain
  thresholds. Unfortunately, the upper threshold is only 80
  RPM - which is insanely low for a road cyclist like myself.
* Steering was impossible. If you adjust the game settings to
  disable auto-shifting, it would turn off steering assist -
  which is the only way to successfully navigate courses in
  the game.
* The maps are way, way, way, way too short. There is some
  bias here because I train hardest for road cycling. Even so,
  the maps are only a mile or so in length.
* "Training" mode is perpetually disabled. I couldn't find a
  way to turn it on, either through the interface or messing
  with the XML files. I don't think it actually exists. If it
  had, this library may not have been necessary (though it
  seems likely, given the other difficulties listed here, that
  it would not sufficed).

I let the bike sit during the summer, rarely riding. When
winter hit hard, I pulled it out and tried again to put it to
good use - and again, I struggled.

It wasn't until a few days prior to the initial release of
this library that I found the time and desire to finally
reverse-engineer the protocol used for the bike's hardware
and make something truly useful out of it. And here you have
it. A little PortMon later (thank heavens it wasn't more
complicated than that) and quite a bit of thinking and
experimenting, and we now have a platform for actually
training with the Trixter Dream Bike.

## Next Steps

Clearly, a new user interface is in order. I'll keep it simple
and target the Raspberry Pi. It will embed well in the bike,
has the necessary guts, and will require nothing more than a
simple HDMI-VGA converter to drive the display.

I may rewrite this in Go as well, depending. Ruby is a great
platform for this kind of prototyping but it may not be the
best for the user interface. We'll see.