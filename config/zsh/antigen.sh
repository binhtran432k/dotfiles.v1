source "$HOME/.antigen/antigen.zsh"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load the theme.
antigen theme romkatv/powerlevel10k

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle dotnet
if [[ -f nvm ]]; then
  antigen bundle nvm
fi
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

## Plugins section: Enable fish style features
# Use history substring search
antigen bundle zsh-users/zsh-history-substring-search
# Fish like autosuggestions
antigen bundle zsh-users/zsh-autosuggestions

# Vi mode
antigen bundle jeffreytse/zsh-vi-mode
# HACK: remove this function after
# https://github.com/jeffreytse/zsh-vi-mode/pull/188 was merged
function zvm_after_init() {
  autoload add-zle-hook-widget
  add-zle-hook-widget zle-line-pre-redraw zvm_zle-line-pre-redraw
}

# NOTE: Must be last bundle to work
# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply
