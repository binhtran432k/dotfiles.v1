# !/bin/zsh
# vim:foldmethod=marker

# {{{ private source
private_source="$HOME/.private.sh"
if [[ -r $private_source ]]; then
  source $private_source
fi
# }}}

source "$HOME/.dmenurc"

zsh_config="$HOME/.config/zsh"
source "$zsh_config/dracula-syntax-highlight.sh"
source "$zsh_config/styles.sh"
source "$zsh_config/antigen.sh"
source "$zsh_config/utils.sh"
source "$zsh_config/functions.sh"
source "$zsh_config/alias.sh"

# {{{ Enviroments
extend_env PATH "$HOME/.luarocks/bin"
extend_env PATH "$HOME/.cargo/bin"
# }}}

# {{{ Theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# }}}

# load auto completion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
