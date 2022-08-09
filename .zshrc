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

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
source_zsh_plugin_file "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# Use powerline
USE_POWERLINE="true"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source_zsh_plugin_file "$HOME/.p10k.zsh"

# Default terminal
replace_env TERMINAL /usr/bin/wezterm
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

v() { nvim "$@" }

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

# Make ranger source directory
alias sclear="printf '\033[2J\033[3J\033[1;1H'"
