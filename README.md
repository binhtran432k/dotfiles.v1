# dotfiles

## Install
```
make install
```

## Sync clock
timedatectl set-local-rtc 0
hwclock --systohc --localtime

## Fix sleep mode not working in Dell
```
sudo make sleep
```
Clean with:
```
sudo make cleansleep
```

## Fix ly beep sound
```
sudo make nobeep
```
Clean with:
```
sudo make cleannobeep
```

## Natural Scrolling
for touchpad search `libinput touchpad catchall`
goto `/usr/share/X11/xorg.conf.d/40-libinput.conf`

Option "NaturalScrolling" "True"
