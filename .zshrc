private_source="$HOME/.private.sh"
if [[ -r $private_source ]]; then
    source $private_source
fi

# Utils
source_zsh_plugin()
{
    if [[ -e $1 ]]; then
        source $1
    fi
}

source_zsh_plugin_file()
{
    if [[ -r $1 ]]; then
        source $1
    fi
}

replace_env()
{
    if [[ -e $2 ]]; then
        eval export $1=\$2
    fi
}

extend_env()
{
    if [[ -e $2 ]]; then
        eval export $1=\$$1:\$2
    fi
}

source_zsh_plugin_file /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source_zsh_plugin_file /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source_zsh_plugin_file /usr/share/zsh/manjaro-zsh-config

# Default terminal
replace_env TERMINAL /usr/bin/kitty
# Default browser
replace_env BROWSER /usr/bin/brave
# Make vim as default editor in terminal
replace_env EDITOR /usr/bin/nvim
replace_env VISUAL /usr/bin/nvim
# Fix vscode trash issue
replace_env ELECTRON_TRASH /usr/bin/gio

extend_env PATH "$HOME/.luarocks/bin"

# Add brave executable to flutter env
replace_env CHROME_EXECUTABLE $BROWSER

# Make hidden file on top with ls
export LC_COLLATE="C"

# Ranger
r() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    /usr/bin/ranger --choosedir="$temp_file" "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}

colors() {
    local fgc bgc vals seq0

    printf "Color escapes are %s\n" '\e[${value};...;${value}m'
    printf "Values 30..37 are \e[33mforeground colors\e[m\n"
    printf "Values 40..47 are \e[43mbackground colors\e[m\n"
    printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

    # foreground colors
    for fgc in {30..37}; do
        # background colors
        for bgc in {40..47}; do
            fgc=${fgc#37} # white
            bgc=${bgc#40} # black

            vals="${fgc:+$fgc;}${bgc}"
            vals=${vals%%;}

            seq0="${vals:+\e[${vals}m}"
            printf "  %-9s" "${seq0:-(default)}"
            printf " ${seq0}TEXT\e[m"
            printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
        done
        echo; echo
    done
}

# Alias

alias v=nvim
alias lg=lazygit

# Make ranger source directory
alias sclear="printf '\033[2J\033[3J\033[1;1H'"

if [ "$TERM" = "linux" ]; then
    printf %b '\e[40m' '\e[8]' # set default background to color 0 'dracula-bg'
    printf %b '\e[37m' '\e[8]' # set default foreground to color 7 'dracula-fg'
    printf %b '\e]P0282a36'    # redefine 'black'          as 'dracula-bg'
    printf %b '\e]P86272a4'    # redefine 'bright-black'   as 'dracula-comment'
    printf %b '\e]P1ff5555'    # redefine 'red'            as 'dracula-red'
    printf %b '\e]P9ff7777'    # redefine 'bright-red'     as '#ff7777'
    printf %b '\e]P250fa7b'    # redefine 'green'          as 'dracula-green'
    printf %b '\e]PA70fa9b'    # redefine 'bright-green'   as '#70fa9b'
    printf %b '\e]P3f1fa8c'    # redefine 'brown'          as 'dracula-yellow'
    printf %b '\e]PBffb86c'    # redefine 'bright-brown'   as 'dracula-orange'
    printf %b '\e]P4bd93f9'    # redefine 'blue'           as 'dracula-purple'
    printf %b '\e]PCcfa9ff'    # redefine 'bright-blue'    as '#cfa9ff'
    printf %b '\e]P5ff79c6'    # redefine 'magenta'        as 'dracula-pink'
    printf %b '\e]PDff88e8'    # redefine 'bright-magenta' as '#ff88e8'
    printf %b '\e]P68be9fd'    # redefine 'cyan'           as 'dracula-cyan'
    printf %b '\e]PE97e2ff'    # redefine 'bright-cyan'    as '#97e2ff'
    printf %b '\e]P7f8f8f2'    # redefine 'white'          as 'dracula-fg'
    printf %b '\e]PFffffff'    # redefine 'bright-white'   as '#ffffff'
    clear
else
    eval "$(starship init zsh)"
fi
