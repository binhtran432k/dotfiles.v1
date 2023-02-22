.PHONY: i u sleep cleansleep

i:
	sh ./configsetup -i
u:
	sh ./configsetup -u
x:
	sh ./configsetup -x
sleep: cleansleep
	sudo mkdir -p /lib/systemd/system-sleep/
	sudo cp -f ./script/xhci.sh /lib/systemd/system-sleep/xhci.sh
	sudo chmod u+x /lib/systemd/system-sleep/xhci.sh
bg: cleanbg
	sudo cp -rf ./.backgrounds /usr/share/backgrounds/user/
cleanbg:
	sudo rm -rf /usr/share/backgrounds/user/
cleansleep:
	sudo rm -f /lib/systemd/system-sleep/xhci.sh
nobeep:
	echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
cleannobeep:
	sudo rm -f /etc/modprobe.d/nobeep.conf
