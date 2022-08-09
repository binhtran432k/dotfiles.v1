.PHONY: i u sumkdir sui sleep cleansleep

i:
	sh ./configsetup -i
u:
	sh ./configsetup -u
sumkdir:
	sudo mkdir -p /usr/share/icons/
	sudo mkdir -p /usr/share/themes/
	sudo mkdir -p /usr/share/color-schemes/
	sudo mkdir -p /usr/share/backgrounds/user
suinstall: sumkdir
	sudo cp -rf ./icons/Dracula-cursors/ /usr/share/icons/
	sudo cp -rf ./themes/Ant-Dracula/ /usr/share/themes/
	sudo cp -rf ./color-schemes/* /usr/share/color-schemes/
	sudo cp -rf ./backgrounds/* /usr/share/backgrounds/user
sleep: cleansleep
	sudo mkdir -p /lib/systemd/system-sleep/
	sudo cp -f ./script/xhci.sh /lib/systemd/system-sleep/xhci.sh
	sudo chmod u+x /lib/systemd/system-sleep/xhci.sh
cleansleep:
	sudo rm -f /lib/systemd/system-sleep/xhci.sh
