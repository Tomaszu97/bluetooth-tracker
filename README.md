# Bluetooth tracker reverse engineering

This repository contains scripts to create and upload custom
tune onto a tile smart bluetooth tracker device.

# Required tools
 - openocd
 - swd pogrammer (chinese stlink v2 will do)
 - dd
 - xxd
 - bash
 - probably a computer

# Tile pro (long one) hookup
 - SWDCLK  -   E13 test pad or second top-left on J11 pads  
 - SWDIO   -   directly to mcu (look nrf52 datasheet)  
 - GND     -   J11 test pads top left when looking so that button is above pads  
 - 3.3V    -   J11 pads, top right, button is above pads - vcc  

# How to hack the ringtone

First go into tools directory. For a song you can use `tune.notes` file
or prepare your own. The format is really simple - first value in a line
is a note, second is its duration. You can look up possible values in a
`dict.notes` file (left column). Lowercase `p` is used instead of `#`.
Values that don't look like notes are durations. Special note `P` is pause
and special duration `Z` is zero duration. `P   Z` needs to be at the beginning
and the end of a preared song.  

Now you need to connect your tile via SWD and dump the firmware.
Be aware that it might work only for this particular model, and probably not
all of firmware versions as song memory locations are hardcoded.
Remember to do a backup of the original firmware - there is no guarantee it
will work after modification.  

Connect to tile using openocd like below. Run openocd from the current directory:  
```
sudo openocd -d2 -f interface/stlink.cfg  -f target/nrf52.cfg
# and in another terminal
telnet localhost 4444
```

Now list available flash memory banks, you should see two:  
```
flash banks
```

Download and backup the firmware (one has to be named in.bin):  

```
flash read_bank 0 in.bin
cp in.bin backup.bin
```

And now the fun part:  
```
./process.sh tune.notes
# now make sure notes.hex and out.bin file was created
# in openocd telnet console
program out.bin
reset
```
Now your custom ringtone should be working. Connect your phone and try it out.
Remember, if you now change a ringtone using your phone, your custom one will
not be played (however it stays in device memory as a backup).
