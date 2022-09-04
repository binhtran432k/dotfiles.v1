.PHONY: paru clean

deps:
	sudo pacman -S --needed base-devel
paru:
	git clone https://aur.archlinux.org/paru-bin.git && \
	cd paru-bin && \
	makepkg -si
install:
	# package manager
	paru -S --needed git
	# themes
	paru -S --needed kvantum-qt5 qt5ct lxappearance papirus-icon-theme \
		papirus-folders
	# util
	paru -S --needed coreutils xdg-utils neofetch btop xclip xsel dmenu \
		redshift bat wget picom polkit polkit-gnome gnome-keyring ly
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
	paru -S --needed brave-bin thunderbird
	# multimedia
	paru -S --needed zathura zathura-pdf-mupdf vlc vimiv-qt goldendict-git gimp \
		inkscape xarchiver ranger-git
	# editor
	paru -S --needed neovim-nightly-bin visual-studio-code-bin
	# music
	paru -S --needed mpc mpd mpdris2 ncmpcpp
	# programming enviroment
	paru -S --needed jdk8-openjdk jdk17-openjdk
clean:
	rm -rf paru-bin
	rm -rf dracula-gtk
	rm -rf src
	rm -rf pkg
	rm -f *.pkg.tar.xz
