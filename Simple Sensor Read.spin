{{
  Simple Sensor Read.spin
  J.R. Leeman
  kd5wxb@gmail.com

  A demonstration to read the sensor humidity and temperature in the
  most simple way.

}}

CON
_clkmode = xtal1 + pll16x
_xinfreq = 5_000_000

  SCL = 4 'SCL Pin
  SDA = 5 'SDA Pin                                                                                                                                                                                                                                                ' 7-bit device ID for EEPROM

VAR
  long temperature,humidity
OBJ
  PST : "Parallax Serial Terminal"
  HTU21D : "HTU21D Spin"

PUB Main

  'Pause to let the user start their terminal
  Pause_MS(2000)

  'Startup the PST terminal
  PST.Start(115200)

  PST.Str(String(13,"Demo of HTU21D Sensor"))
  PST.Str(String(13,"Returns Relative Humidity and Temperature"))
  PST.Str(String(13,"Temperature in tenths of a degree C"))
  PST.Str(String(13,"Humidity in tenths of a percent RH"))

  'Start the Sensor
  HTU21D.Init(SCL,SDA)

  repeat
    HTU21D.Read(@temperature,@humidity)

    PST.Str(String(13))
    PST.dec(temperature)
    PST.Str(String(","))
    PST.dec(humidity)
    Pause_MS(2000)

PRI Pause_MS(mS)
  waitcnt(clkfreq/1000 * mS + cnt)

CON
{{
                            TERMS OF USE: MIT License

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
}}