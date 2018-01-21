#!/usr/bin/env ruby

def dir
  fp = File.open "/sys/bus/iio/devices/iio:device0/in_voltage0_raw"
  d = fp.gets.chomp.to_i
  fp.close
  return d
end

xmin = 5000
xmax = 0

while true
  x = dir
  if x < xmin
    xmin = x
    puts "min: #{xmin}   max = #{xmax}"
    next
  end

  if x > xmax
    xmax = x
    puts "min: #{xmin}   max = #{xmax}"
    next
  end
end


