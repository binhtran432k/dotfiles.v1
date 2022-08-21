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

extend_env PATH "$HOME/.luarocks/bin"

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

eval "$(starship init zsh)"
