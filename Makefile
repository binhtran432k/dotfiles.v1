install: clean mkdir
	ln -sf ~/dotfiles/.zshrc ~/.zshrc
	ln -sf ~/dotfiles/.profile ~/.profile
	ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
	ln -sf ~/dotfiles/.Xresources ~/.Xresources
	ln -sf ~/dotfiles/.dmenurc ~/.dmenurc
	ln -sf ~/dotfiles/.dir_colors ~/.dir_colors
	chmod +x ~/dotfiles/script/brave-popup
	chmod +x ~/dotfiles/script/i3lock-color
	chmod +x ~/dotfiles/script/i3exit-color
	ln -sf ~/dotfiles/script/brave-popup ~/.local/bin/
	ln -sf ~/dotfiles/script/i3lock-color ~/.local/bin/
	ln -sf ~/dotfiles/script/i3exit-color ~/.local/bin/
	ln -snf ~/dotfiles/.config/nvim ~/.config/nvim
	ln -snf ~/dotfiles/.config/i3 ~/.config/i3
	ln -snf ~/dotfiles/.config/i3status ~/.config/i3status
	ln -snf ~/dotfiles/.config/dunst ~/.config/dunst
	ln -snf ~/dotfiles/.config/kitty ~/.config/kitty
	ln -snf ~/dotfiles/.config/ranger ~/.config/ranger
	ln -snf ~/dotfiles/.config/pulseaudio-ctl ~/.config/pulseaudio-ctl
	ln -snf ~/dotfiles/.config/polybar ~/.config/polybar
	ln -snf ~/dotfiles/.config/conky ~/.config/conky
	ln -snf ~/dotfiles/.config/geoclue ~/.config/geoclue
	ln -snf ~/dotfiles/.config/Kvantum ~/.config/Kvantum
	ln -snf ~/dotfiles/.config/i3status-rust ~/.config/i3status-rust
	ln -snf ~/dotfiles/.config/zathura ~/.config/zathura
	ln -snf ~/dotfiles/.config/dmenu-recent ~/.config/dmenu-recent
	ln -snf ~/dotfiles/.config/btop ~/.config/btop
	ln -snf ~/dotfiles/.config/ncmpcpp ~/.config/ncmpcpp
	ln -snf ~/dotfiles/.config/mpd ~/.config/mpd
	ln -snf ~/dotfiles/.config/neofetch ~/.config/neofetch
	ln -snf ~/dotfiles/.config/morc_menu ~/.config/morc_menu
	ln -snf ~/dotfiles/.config/qutebrowser ~/.config/qutebrowser
	ln -snf ~/dotfiles/.config/mutt ~/.config/mutt
	ln -snf ~/dotfiles/.config/msmtp ~/.config/msmtp
	ln -snf ~/dotfiles/.config/picom.conf ~/.config/picom.conf
	ln -snf ~/dotfiles/.config/redshift.conf ~/.config/redshift.conf
	ln -snf ~/dotfiles/.fonts ~/.fonts
	ln -snf ~/dotfiles/.goldendict ~/.goldendict
mkdir:
	mkdir -p ~/.local/bin/
	mkdir -p ~/.config/
clean:
	rm -rf ~/.local/bin/brave-popup
	rm -rf ~/.local/bin/i3lock-color
	rm -rf ~/.local/bin/i3exit-color
	rm -rf ~/.config/nvim
	rm -rf ~/.config/i3
	rm -rf ~/.config/i3status
	rm -rf ~/.config/dunst
	rm -rf ~/.config/kitty
	rm -rf ~/.config/ranger
	rm -rf ~/.config/pulseaudio-ctl
	rm -rf ~/.config/polybar
	rm -rf ~/.config/conky
	rm -rf ~/.config/geoclue
	rm -rf ~/.config/Kvantum
	rm -rf ~/.config/i3status-rust
	rm -rf ~/.config/zathura
	rm -rf ~/.config/dmenu-recent
	rm -rf ~/.config/btop
	rm -rf ~/.config/ncmpcpp
	rm -rf ~/.config/mpd
	rm -rf ~/.config/neofetch
	rm -rf ~/.config/morc_menu
	rm -rf ~/.config/qutebrowser
	rm -rf ~/.config/mutt
	rm -rf ~/.config/msmtp
	rm -rf ~/.fonts
	rm -rf ~/.goldendict
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
