# Maintained in linux-config.org
logger -t "startup-initfile"  ZLOGIN
# [ -s "${HOME}/.rvm/scripts/rvm" ] && source "${HOME}/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
if [[ -z $DOT_PROFILE_SOURCED ]]; then
    if [ -f ~/.profile ]; then
        emulate sh -c '. ~/.profile'
    fi
fi
if [ "$(tty)" = "/dev/tty1" ];then
    chuck
    sway-autostart
fi
