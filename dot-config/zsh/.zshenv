# Maintained in linux-config.org
logger -t "startup-initfile"  ZSHENV
if [ -z "$XDG_CONFIG_HOME" ] && [ -d "${HOME}/.config" ]
then
    export XDG_CONFIG_HOME="${HOME}/.config"
fi

xhost +SI:localuser:root &> /dev/null
