install:
	ln -sf ~/dotfiles/.zshrc ~/.zshrc
	ln -sf ~/dotfiles/.profile ~/.profile
	ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
	ln -sf ~/dotfiles/.Xresources ~/.Xresources
	ln -sf ~/dotfiles/.dmenurc ~/.dmenurc
	ln -sf ~/dotfiles/.dir_colors ~/.dir_colors
	mkdir -p ~/.local/bin/
	chmod +x ~/dotfiles/script/brave-popup
	ln -sf ~/dotfiles/script/brave-popup ~/.local/bin/
	mkdir -p ~/.config/
	ln -sf ~/dotfiles/.config/nvim/ ~/.config/
	ln -sf ~/dotfiles/.config/i3/ ~/.config/
	ln -sf ~/dotfiles/.config/dunst/ ~/.config/
	ln -sf ~/dotfiles/.config/kitty/ ~/.config
	ln -sf ~/dotfiles/.config/ranger/ ~/.config
	ln -sf ~/dotfiles/.config/pulseaudio-ctl/ ~/.config
	ln -sf ~/dotfiles/.config/polybar/ ~/.config
	ln -sf ~/dotfiles/.config/i3status/ ~/.config
	ln -sf ~/dotfiles/.config/conky/ ~/.config
	ln -sf ~/dotfiles/.config/geoclue/ ~/.config
	ln -sf ~/dotfiles/.config/aurorae/ ~/.config
	ln -sf ~/dotfiles/.config/color-schemes/ ~/.config
	ln -sf ~/dotfiles/.config/cursors/ ~/.config
	ln -sf ~/dotfiles/.config/plasma/ ~/.config
	ln -sf ~/dotfiles/.config/Kvantum/ ~/.config
	ln -sf ~/dotfiles/.config/zathura/ ~/.config
	ln -sf ~/dotfiles/.config/picom.conf ~/.config
	ln -sf ~/dotfiles/.config/redshift.conf ~/.config
suinstall:
	sudo cp -rf ./icons/Dracula-cursors/ /usr/share/icons/
	sudo cp -rf ./themes/Ant-Dracula/ /usr/share/themes/
	sudo cp -rf ./color-schemes/* /usr/share/color-schemes/
	sudo mkdir -p /usr/share/backgrounds/user
	sudo cp -rf ./backgrounds/* /usr/share/backgrounds/user
