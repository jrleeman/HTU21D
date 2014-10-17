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

VAR
long crc

OBJ
  I2C  : "I2C SPIN driver v1.2"
  F    : "FloatMath"
  FS    : "FloatString"
  PST  : "Parallax Serial Terminal"

PUB Main
  PST.Start(115200)
  PST.Str(String("DEBUG SERIAL TERMINAL:"))

  'Startup the I2C bus
  PST.Str(String(13,"Starting the I2C Bus"))
  Start(6,7) 
  PST.Str(String(13,"Complete"))

  'Do a Soft Rest of the unit
  SoftReset

  'Loop and read the sensor over and over
  repeat
    ReadTemp
    ReadHumid
    Pause_MS(1000)

PUB Start(scl,sda)

  SCL := scl
  SDA := sda

  I2C.start(SCL,SDA)
  
PUB SoftReset
  PST.Str(String(13,"Writing Reset"))
  I2C.command($80,$FE)
  PST.Str(String(13,"Reset Sent"))
  Pause_MS(15) 'Wait 15 mS for reset per datasheet

PUB ReadTemp : T
  I2C.command($80,$F3)  'Start temperature conversion
  Pause_MS(1000) 'Wait a long time for testing
  
  T :=  I2C.read_word($81,$E7)
  crc := I2C.read($81,$E7)

  T := T & $FFFC
  T := F.FFloat(T)
  T := F.FDiv(T,65536.0)
  T := F.FMul(T,175.72)
  T := F.FSub(T,46.85)
  
  PST.Str(String(13,"T (C): "))
  PST.Str(FS.FloatToString(T))

PUB ReadHumid : humidity
  ' Trigger No Hold Master Humidity Measurement
  I2C.command($80,$F5)
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

PUB Pause_MS(mS)
  waitcnt(clkfreq/1000 * mS + cnt)