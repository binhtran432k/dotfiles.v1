.PHONY: paru deps install clean

deps:
	sudo pacman -S --needed base-devel
install:
	git clone https://aur.archlinux.org/paru-bin.git && \
	cd paru-bin && \
	makepkg -si
paru:
	# package manager
	paru -S --needed git npm luarocks
	# themes
	paru -S --needed kvantum-qt5 qt5ct lxappearance papirus-icon-theme \
		papirus-folders i3status-rust
	# util
	paru -S --needed coreutils xdg-utils neofetch btop xclip xsel \
		redshift bat wget picom polkit polkit-gnome gnome-keyring \
		ibus-bamboo-git zsh zsh-completions xfce4-power-manager feh \
		lazygit zip unzip xss-lock safeeyes xprintidle
	# audio
	paru -S --needed pulseaudio pulseaudio-bluetooth pavucontrol
	# network
	paru -S --needed networkmanager network-manager-applet bluez bluez-utils
	# font
	paru -S --needed ttf-cascadia-code ttf-nerd-fonts-symbols ttf-font-awesome \
		ttf-font-icons noto-fonts noto-fonts-emoji ttf-liberation
	# terminal
	paru -S --needed kitty rxvt-unicode
	# browser
	paru -S --needed brave-browser thunderbird
	# multimedia
	paru -S --needed zathura zathura-pdf-mupdf vlc vimiv-qt goldendict-git gimp \
		inkscape xarchiver ranger-git
	# editor
	paru -S --needed neovim-nightly-bin visual-studio-code-bin
	# music
	paru -S --needed mpc mpd mpdris2 ncmpcpp
	# programming enviroment
	paru -S --needed jdk8-openjdk jdk17-openjdk nodejs fennel
clean:
	rm -rf paru-bin
	rm -rf dracula-gtk
	rm -rf src
	rm -rf pkg
	rm -f *.pkg.tar.xz
