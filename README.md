# Description

Read Sparkfun SEN-08942 weather meters (windspeed, direction, and rain) on a Beaglebone using GPIO and Analog input kernel support, logging every second the number of rain drops, the number of windspeed ticks (4 of them sum up to 0.667 m/sec) and the wind direction (0 to 15, aka "relative North" to "relative North-North-West" depending on the physical orientation of the contraption).

On a 720 MHz Beaglebone Original ("white") the Ruby script requires as low as 0.1% CPU time, so that the board can run quite a lot of other things. It should work on any board featuring GPIOs and *in_voltage0_raw*-like analog inputs (you may need the "cape trick" as explained [here](https://www.teachmemicro.com/beaglebone-black-adc/)). Note that GPIO initialization requires root privileges.

## Installation

The weather meters come with two cables: the rain gauge one (two pins to be connected to GPIO 67, aka P8.8, and GND, aka P8.1 or P8.2) and the wind group one (four pins, to be connected to AIN GND aka P9.34, GPIO 68 aka P8.10, GND aka P9.1 or P9.2, and AIN 0 aka P9.39- the latter on the resistor divider circuit connected to AIN VDC aka P9.32 and a ~12k resistor).

The anemometer values are calculated on a ~12k resistor (not a ~10k as in the Arduino examples from other people). Use the *test-wind-direction-finder.rb* script to find out the 16 direction values (min/max) and sort them by index. The wind direction lowest values here were 206 to 224, the next to lowest one showed 267 to 285; I chose 245 as a safe value between the max value of direction 0 (relative "North") and the min value of direction 1 (relative "North-North-East").

My SEN-8942 is an old one featuring two reed switches in the anemometer, that is four GPIO events (rise/fall + rise/fall interrupts), this is why I need 4 ticks to get a reliable speed value.

## Notes

Italian description [here](https://particolarmente-urgentissimo.blogspot.com/2018/01/hmm-piaceri-e-dolori.html).
