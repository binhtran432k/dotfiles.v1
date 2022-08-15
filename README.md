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
