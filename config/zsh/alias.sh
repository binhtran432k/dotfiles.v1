alias v=nvim
alias nvimm="nvim -u /etc/vimrc"
alias lg=lazygit

# Make ranger source directory
alias sclear="printf '\033[2J\033[3J\033[1;1H'"
alias paru-devel="pacman -Qmq | grep -Ee '-(cvs|svn|git|hg|bzr|darcs|nightly-bin)$' | paru -Ta - | paru -S --needed -"
alias upnvim="pamac install neovim-nightly-bin"
