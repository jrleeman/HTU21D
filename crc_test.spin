CON
_clkmode = xtal1 + pll16x
_xinfreq = 5_000_000

VAR
long crc8,data,poly,mask
byte i 

OBJ
  PST : "Parallax Serial Terminal"

PUB Main
  'Pause to let the user start their terminal
  Pause_MS(2000)

  'Startup the PST terminal
  PST.Start(115200)

  PST.Str(String(13,"Demo of CRC8"))

  poly := %100110001
  data := %11011100
  data := $683A
  'data := $4E85

  i := 0
  data := data << 8
  data := data | %01111100
  poly := poly << 15
  crc8 := data
  mask := $1 << 23
  
  PST.Str(String(13,"CRC8: "))
  PST.bin(crc8,24)
  repeat 16
    
    PST.Str(String(13,"MASK: "))
    PST.bin(mask>>i,24)
    if ((crc8 & (mask>>i)) <> (mask>>i))
      crc8 := crc8 ^ $0000
      PST.Str(String(13,"POLY: "))
      PST.bin($0000,24)

    else
      crc8 := crc8 ^ (poly >> i)
      PST.Str(String(13,"POLY: "))
      PST.bin(poly>>i,24)

    PST.Str(String(13,"-------------------------"))
    
    PST.Str(String(13,"CRC8: "))
    PST.bin(crc8,24)
     
    i := i + 1

PST.Str(String(13,"FINAL : "))
PST.bin(crc8,16)

PRI Pause_MS(mS)
  waitcnt(clkfreq/1000 * mS + cnt)  