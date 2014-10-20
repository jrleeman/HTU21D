# HTU21D Digital Humidity Sensor with Temperature Output


## NOTICE: This object is currently under development and may or may not work in its current state.

This code reads the HTU21D digital relative humidity sensor with temperature
output, manufactured by measurement specialties. Currently
support for the Parallax Propeller in SPIN to supplement existing code
for the Arduino provided by SparkFun Electronics. Testing was done with
the HTU21D breakout board (link below) and a Propeller ASC+.

### Sensor Details
[Sensor Breakout (Sparkfun)](https://www.sparkfun.com/products/12064)

[Sensor Datasheet](https://github.com/jrleeman/HTU21D/blob/master/HTU21D.pdf?raw=true)

[Arudino Library (Sparkfun Download)](http://dlnmh9ip6v2uc.cloudfront.net/datasheets/BreakoutBoards/HTU21DLibrary.zip)

### Setup
To-do when code is reading sensor correctly.

### Files
* **HTU21D Spin.spin** - Spin object to read the sensor
* **HTU21D.pdf** - Local copy of device datasheet
* **I2C Spin driver v1.2.spin** - I2C driver local copy
* **README.md** - This file

### Notes
* This used Chris Gadd's [I2C Routines object](http://obex.parallax.com/object/700) found on the [Parallax Object Exchange](http://obex.parallax.com/)
* Pull-ups are required with this setup, but that can be modified by using the
  push-pull object in the I2C Routines.
