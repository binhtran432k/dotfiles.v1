# vim:set ft=bash:
# Setup default
if [[ $DESKTOP_SESSION != 'plasma' ]]; then
	export QT_QPA_PLATFORMTHEME="qt5ct"
	export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
	export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
fi

export BROWSER=/usr/bin/brave
export EDITOR=nvim
export TERMINAL=/usr/bin/kitty
export TERMINAL_CMD="$TERMINAL -e"

# Setup ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT4_IM_MODULE=ibus
export CLUTTER_IM_MODULE=ibus
export GLFW_IM_MODULE=ibus

# Fix vscode trash issue
export ELECTRON_TRASH=/usr/bin/gio
# Add brave executable to flutter env
export CHROME_EXECUTABLE=$BROWSER
# Make vim as default editor in terminal
export VISUAL=$EDITOR
# Make hidden file on top with ls
export LC_COLLATE="C"

# Neovide
# export NEOVIDE_MULTIGRID=true

# ibus-daemon -drxR
