{{
  HTU21D Pressure Sensor Object
  J.R. Leeman
  kd5wxb@gmail.com

  This is a driver that uses the I2C SPIN driver v1.2 for the I2C communication.
  Sensor details and reading methodology can be found in the datasheet from
  measurement spealties. Code was tested with the HTU21D breakout board from
  Sparkfun Electronics.

  Use:
  - Call Init with SCL,SDA pins

}}

CON
  ' Address of the HTU21D
  ADR = $40

DAT
  ' Conversion time for different resolutions
   ConvTime byte 5,8,14,26

VAR
  long T,RH

OBJ
  I2C  : "I2C SPIN driver v1.2"
  F    : "FloatMath"

PUB Init(scl,sda)

  SCL := scl
  SDA := sda

  I2C.start(SCL,SDA)

PUB SoftReset
  I2C.write(ADR,$80,$FE)
  Pause_MS(15) 'Wait 15 mS for reset

PUB ReadTemp : T
  I2C.write($F3)  ' Start temperature conversion
  Pause_MS(100)

  T :=  I2C.r e a d _ w o r d ( ADR,$81)

  PST.Str(String(13,"Temperature ADC: $"))
  PST.hex(temperature,4)
  checksum := I2C.read_next(ADR)
  PST.Str(String(13,"Temperature Checksum: $"))
  PST.hex(checksum,2)

  T := T & $FFFC
  T := F.FFloat(T)
  T := F.FDiv(T,65536.0)
  T := F.FMul(T,175.72)
  T := F.FSub(T,46.85)
  return T


PRI Pause_MS(mS)
  waitcnt(clkfreq / 1000 * mS + cnt)

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
