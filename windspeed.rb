#!/usr/bin/env ruby

gpio = 68
open("/sys/class/gpio/export", "w").puts gpio
open("/sys/class/gpio/gpio#{gpio}/edge", "w").puts "both"
fds = [ open("/sys/class/gpio/gpio#{gpio}/value") ]
lastt = 0
ticks = 0
max = 3.6

while true
  _, _, rdy = select(nil, nil, fds)
  next  unless rdy

  t = Time.now.to_f
  rdy.first.rewind
  rdy.first.read 1

  ticks += 1
  next  if ticks < 4    # require 4 ticks = at least 1 rotation
  ticks = 0

  diff = t - lastt
  lastt = t
  diff = 5.0  if diff > 5.0
  spd = 2.40114121 / diff
  max = spd  if max < spd
  puts "\t%.2f m/s\t%5.1f km/h\t%f sec\t\t%5.1f km/h max" % [ 0.66698368 / diff, spd, diff, max ]

# woot! my best breath output was 9.88 m/s (35.6 km/h, 22.10 mph)

end

