#!/usr/bin/env ruby

ANEMO_VOL=[ [ 245,9 ], [ 293,7 ], [ 367,8 ], [ 525,11 ], [ 733,10 ], [ 917,13 ], [ 1215,12 ], [ 1549,5 ],
            [ 1931,6 ], [ 2269,15 ], [ 2483,14 ], [ 2811,3 ], [ 3087,4 ], [ 3317,1 ], [ 3585,2 ], [ 4095,0 ] ]

def winddir
  x = open("/sys/bus/iio/devices/iio:device0/in_voltage0_raw").gets.to_i
  ANEMO_VOL.each { |r,d|  return d  if x <= r }
end


def config gpio
  open("/sys/class/gpio/export", 'w').puts gpio
  open("/sys/class/gpio/gpio#{gpio}/edge", 'w').puts 'both'
  open("/sys/class/gpio/gpio#{gpio}/value")
end


# -- main --

lastt, rain, wind, fd = 0, 0, 0, [ config(67), config(68) ]
while true
  t = Time.now
  if t.to_i != lastt
    lastt = t.to_i
    puts "> r#{rain} s#{wind} d#{winddir}"
    rain, wind = 0, 0
  end

  _, _, fds = select nil, nil, fd, t.to_f.ceil - t.to_f
  if fds
    fds.each do |f|
      sleep 0.002  # 2 msec pause for safe debounce
      f.rewind
      f.read 1
      if f == fd.first
        rain += 1
      else
        wind += 1
      end
    end
  end
end

