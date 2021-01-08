# Maintained in linux-init-files.org
logger -t "startup-initfile"  BASH_PROFILE

[ -f ~/.profile ] && . ~/.profile || true
[ -f ~/.bashrc ] && . ~/.bashrc || true

post-lock
[ -d "/home/.ecryptfs/$USER" ] && systemctl --user restart mbsync.timer || true
dropbox-start-once async

# export USER_STARTX_NO_LOGOUT_ON_QUIT=""
[ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] && [ -f ~/.START_X ] && {
    echo "Auto starting via startx with USER_STARTX_NO_LOGOUT_ON_QUIT:${USER_STARTX_NO_LOGOUT_ON_QUIT}"
    [ -z "$USER_STARTX_NO_LOGOUT_ON_QUIT" ] && exec startx || startx
}
