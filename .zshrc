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

# Source manjaro-zsh-configuration
source_zsh_plugin /usr/share/zsh/manjaro-zsh-config
# Use manjaro zsh prompt
source_zsh_plugin /usr/share/zsh/manjaro-zsh-prompt
# Use zsh vi mode
source_zsh_plugin_file /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source_zsh_plugin_file ~/.p10k.zsh

### User export
media_disk="/run/media/binhtran432k/Media"
data_disk="/run/media/binhtran432k/data"

# Default terminal
replace_env TERMINAL /usr/bin/kitty
# Default browser
replace_env BROWSER /usr/bin/brave
# Make vim as default editor in terminal
replace_env EDITOR /usr/bin/nvim
replace_env VISUAL /usr/bin/nvim
# Fix vscode trash issue
replace_env ELECTRON_TRASH /usr/bin/gio

# Add texlive to MANPATH, INFOPATH, PATH
extend_env MANPATH "$media_disk/tools/texlive/texmf-dist/doc/man"
extend_env INFOPATH "$media_disk/tools/texlive/texmf-dist/doc/info"
extend_env PATH "$media_disk/tools/texlive/bin/x86_64-linux"

# Add brave executable to flutter env
replace_env CHROME_EXECUTABLE $BROWSER

# Add Android Studio Command line tools to PATH
extend_env PATH "$media_disk/tools/Android/Sdk/cmdline-tools/latest/bin"
extend_env PATH "$media_disk/tools/Android/Sdk/platform-tools"

replace_env ANDROID_SDK_ROOT "$media_disk/tools/Android/Sdk"
# Plantuml
replace_env PLANTUML_JAR "$media_disk/tools/plantuml/plantuml.jar"

# Add flutter to PATH
extend_env PATH="$media_disk/tools/flutter/bin"

# Make ranger source directory
alias sclear="printf '\033[2J\033[3J\033[1;1H'"

# Goldendict
replace_env GOLDENDICT_PATH "$media_disk/GoldenDict"
