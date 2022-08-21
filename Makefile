.PHONY: i u sleep cleansleep

i:
	sh ./configsetup -i
u:
	sh ./configsetup -u
sleep: cleansleep
	sudo mkdir -p /lib/systemd/system-sleep/
	sudo cp -f ./script/xhci.sh /lib/systemd/system-sleep/xhci.sh
	sudo chmod u+x /lib/systemd/system-sleep/xhci.sh
cleansleep:
	sudo rm -f /lib/systemd/system-sleep/xhci.sh
nobeep:
	echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
cleannobeep:
	sudo rm -f /etc/modprobe.d/nobeep.conf
