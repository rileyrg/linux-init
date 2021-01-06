# Maintained in linux-init-files.org
logger -t "startup-initfile"  BASH_PROFILE

[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

post-lock

command -v dropbox &> /dev/null  && sleep 15 && dropbox start &> /dev/null &


[[ -f ~/.bash_profile.local ]] && . ~/.bash_profile.local

# export USER_STARTX_NO_LOGOUT_ON_QUIT=""
[[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]] && [[ -f ~/.START_X ]] && {
    echo "Auto starting via startx with USER_STARTX_NO_LOGOUT_ON_QUIT:${USER_STARTX_NO_LOGOUT_ON_QUIT}"
    [[ -z "$USER_STARTX_NO_LOGOUT_ON_QUIT" ]] && exec startx || startx
}
