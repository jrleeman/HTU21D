{{
  HTU21D Pressure Sensor Object
  J.R. Leeman
  kd5wxb@gmail.com

  This is a driver that uses the I2C SPIN driver v1.2 for the I2C communication.
  Sensor details and reading methodology can be found in the datasheet from
  measurement specialties. Code was tested with the HTU21D breakout board from
  Sparkfun Electronics.

  Use:
  - Call Init with SCL,SDA pins

}}

CON
  ' Address of the humidity sensor
  ADR = $40

VAR
byte msb,lsb,crc,crc_calc

OBJ
  I2C  : "I2C SPIN driver v1.2"
  F    : "FloatMath"

PUB Init(scl,sda)
  ' Start the I2C object
  SCL := scl
  SDA := sda
  I2C.start(SCL,SDA)

PUB SoftReset
  ' Do a soft reset, recommended after
  ' repowering the unit
  if \I2C.command($40,$FE)
    Pause_MS(15) 'Wait 15 mS for reset per datasheet

PUB CRC8(data,crcdata,poly)| checksum,i,mask
  i := 0
  data := (data << 8) | crcdata
  poly := poly << 15
  checksum := data
  mask := $1 << 23

  repeat 16

    if ((checksum & (mask>>i)) <> (mask>>i))
      checksum := checksum ^ $0000

    else
      checksum := checksum ^ (poly >> i)
     
    i := i + 1

  RESULT := checksum

PUB Read(TempPtr,HumidPtr)
  ' Read humidity and temperature and return to
  ' passed pointers
  Long[TempPtr] := ReadTemp
  Long[HumidPtr] := ReadHumidity

PRI ReadTemp : T
  ' Write temperature conversion command
  \I2C.command(ADR,$E3)
  T := (\I2C.read_next(ADR) << 8) | \I2C.read_next(ADR)
  crc := \I2C.read_next(ADR)

  T := T & $FFFC
  T := F.FFloat(T)
  T := F.FDiv(T,65536.0)
  T := F.FMul(T,175.72)
  T := F.FSub(T,46.85)
  T := F.FMul(T,10.0) 
  T := F.FTrunc(T)


PUB ReadHumidity : RH
  ' Trigger Humidity Measurement
  \I2C.command(ADR,$E5)

  RH := (\I2C.read_next(ADR) << 8) | \I2C.read_next(ADR)
  crc := \I2C.read_next(ADR)

  RH := RH & $FFFC
  RH := F.FFloat(RH)
  RH := F.FDiv(RH,65536.0)
  RH := F.FMul(RH,125.0)
  RH := F.FSub(RH,6.0)
  RH := F.FMul(RH,10.0)
  RH := F.FTrunc(RH)


PUB Pause_MS(mS)
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