# Maintained in linux-init-files.org
logger -t "startup-initfile"  ZSHENV
if [ -z "$XDG_CONFIG_HOME" ] && [ -d "$HOME/.config" ]
then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -d "$XDG_CONFIG_HOME/zsh" ]
then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
