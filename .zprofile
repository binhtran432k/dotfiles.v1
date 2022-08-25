# Setup default
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=/usr/bin/brave
export EDITOR=/usr/bin/nvim
export TERMINAL=/usr/bin/kitty
export TERMINAL_CMD="$TERMINAL -e"

# Setup ibus
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT4_IM_MODULE=fcitx
export CLUTTER_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx

# Fix vscode trash issue
export ELECTRON_TRASH=/usr/bin/gio
# Add brave executable to flutter env
export CHROME_EXECUTABLE=$BROWSER
# Make vim as default editor in terminal
export VISUAL=$EDITOR
# Make hidden file on top with ls
export LC_COLLATE="C"

# Neovide
export NEOVIDE_MULTIGRID=true

# Setup tbsm
# [[ -n "$XDG_VTNR" && $XDG_VTNR -le 2 ]] && exec tbsm

# If running from tty1 manual start sway
[ "$(tty)" = "/dev/tty1" ] && exec sway
