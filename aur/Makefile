.PHONY: paru deps install clean

deps:
	sudo pacman -Syu && sudo pacman -S --needed base-devel
install:
	rm -rf paru-bin
	git clone https://aur.archlinux.org/paru-bin.git && \
	cd paru-bin && \
	makepkg -si
ii3: icommon
	# themes
	paru -S --needed qt5ct lxappearance papirus-icon-theme \
		papirus-folders i3status-rust
	# util
	paru -S --needed redshift picom polkit polkit-gnome gnome-keyring \
		xfce4-power-manager feh \
		lazygit xss-lock
	# audio
	paru -S --needed pulseaudio pulseaudio-bluetooth pavucontrol
	# network
	paru -S --needed networkmanager network-manager-applet bluez bluez-utils
	# multimedia
	paru -S --needed zathura zathura-pdf-mupdf vimiv-qt xarchiver
	# music
	paru -S --needed mpc mpd mpdris2 ncmpcpp
icommon:
	# boot
	paru -S --needed plymouth plymouth-theme-manjaro
	# util
	paru -S --needed coreutils xdg-utils btop neofetch dragon-drop ripgrep bat \
		wget ueberzug cloudflare-warp-bin
	# themes
	paru -S --needed kvantum-qt5
	# util
	paru -S --needed xclip xsel zsh zsh-completions ibus-bamboo-git gnome-keyring zip unzip safeeyes xprintidle
	# package manager
	paru -S --needed git npm luarocks
	# multimedia
	paru -S --needed vlc goldendict-git gimp inkscape obs-studio ranger-git
	# terminal
	paru -S --needed kitty
	# font
	paru -S --needed ttf-cascadia-code ttf-nerd-fonts-symbols-2048-em ttf-font-awesome \
		ttf-font-icons noto-fonts noto-fonts-emoji ttf-liberation
	# software
	paru -S --needed brave-browser thunderbird
	# editor
	paru -S --needed visual-studio-code-bin neovim-nightly-bin
	# programming enviroment
	paru -S --needed jdk-openjdk nodejs fennel virtualbox \
		virtualbox-ext-oracle docker dotnet-sdk
kde:
	paru -S --needed latte-dock-git plasma5-applets-window-appmenu-git plasma5-applets-window-title-git \
		plasma5-applets-kpplemenu-git plasma5-applets-betterinlineclock-git plasma5-applets-latte-separator appmenu-gtk-module sweet-theme-full-git
clean:
	rm -rf paru-bin
	rm -rf dracula-gtk
	rm -rf src
	rm -rf pkg
	rm -f *.pkg.tar.xz
