# Setup default
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=/usr/bin/brave
export EDITOR=/usr/bin/nvim

# Setup ibus
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT4_IM_MODULE=fcitx
export CLUTTER_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx

# Setup tbsm
# [[ -n "$XDG_VTNR" && $XDG_VTNR -le 2 ]] && exec tbsm

# If running from tty1 manual start sway
[ "$(tty)" = "/dev/tty1" ] && exec sway
