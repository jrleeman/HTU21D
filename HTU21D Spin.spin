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
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

CON
  ' Address of the HTU21D
  ADR = $40

VAR
long crc

OBJ
  I2C  : "I2C SPIN driver v1.2"
  F    : "FloatMath"
  FS    : "FloatString"
  PST  : "Parallax Serial Terminal"

PUB Main
  PST.Start(115200)                              ' Start the Parallax Serial Terminal cog
  PST.Str(String("DEBUG SERIAL TERMINAL:"))       ' Heading
  'Start(6,7)
  I2C.start(6,7)
  I2C.command($80,$FE)

'PUB Start(scl,sda)

'  SCL := scl
'  SDA := sda

  'I2C.start(SCL,SDA)
'  I2C.start(6,7)
  'I2C.I2C_start
'  Pause_MS(1000)
  'PST.Str(String(13,"Write Command Register"))
  'I2C.write($80,$E6,%01000000)
  'PST.Str(String(13,"Complete"))

'  SoftReset
'  repeat
'    PST.Str(String(13,"In Loop"))
'    ReadTemp
'    ReadHumid
'    Pause_MS(1000)

PUB SoftReset
  PST.Str(String(13,"Writing Reset"))
  I2C.command($80,$FE)
  PST.Str(String(13,"Reset Sent"))
  Pause_MS(15) 'Wait 15 mS for reset

PUB ReadTemp : T
  I2C.write($80,$E6,$E3)  ' Start temperature conversion
  Pause_MS(1000)
  T :=  I2C.read_word($81,$E7)
  crc := I2C.read($81,$E7)

  'PST.hex(T,4)

  T := T & $FFFC
  T := F.FFloat(T)
  T := F.FDiv(T,65536.0)
  T := F.FMul(T,175.72)
  T := F.FSub(T,46.85)
  PST.Str(String(13,"T (C): "))
  PST.Str(FS.FloatToString(T))

PUB ReadHumid : humidity
  ' Trigger No Hold Master Humidity Measurement
   I2C.write($80,$E6,$E5)
   Pause_MS(1000)
   humidity :=  I2C.read_word($81,$E7)
   crc := I2C.read($81,$E7)


  humidity := humidity & $FFFC
  humidity := F.FFloat(humidity)
  humidity := F.FDiv(humidity,65536.0)
  humidity := F.FMul(humidity,125.0)
  humidity := F.FSub(humidity,6.0)
  PST.Str(String(13,"RH (%): "))
  PST.Str(FS.FloatToString(humidity))
  return humidity

PUB Pause_MS(mS)
  waitcnt(clkfreq/1000 * mS + cnt)
