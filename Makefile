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
	ln -sf ~/dotfiles/.config/nvim/ ~/.config
	ln -sf ~/dotfiles/.config/i3/ ~/.config
	ln -sf ~/dotfiles/.config/dunst/ ~/.config
	ln -sf ~/dotfiles/.config/kitty/ ~/.config
	ln -sf ~/dotfiles/.config/ranger/ ~/.config
	ln -sf ~/dotfiles/.config/pulseaudio-ctl/ ~/.config
	ln -sf ~/dotfiles/.config/polybar/ ~/.config
	ln -sf ~/dotfiles/.config/i3status/ ~/.config
	ln -sf ~/dotfiles/.config/picom.conf ~/.config
