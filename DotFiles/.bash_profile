#!/usr/bin/env bash
# Maintained in linux-config.org
logger -t "startup-initfile"  BASH_PROFILE
[ -f ~/.profile ] && . ~/.profile || true
[ -f ~/.bashrc ] && . ~/.bashrc || true
#emacs --bg-daemon  &> /dev/null &

if [ -d "/gnu" ]; then
    echo "GUIX initialised."
    GUIX_PROFILE="/home/rgr/.guix-profile"
    . "$GUIX_PROFILE/etc/profile"
fi

mkdir -p "$HOME/hetzner"
if ! mountpoint -q "$HOME/hetzner"; then
    (command -v rclone && rclone mount --read-only  hetzner: "$HOME/hetzner") &> /dev/null &
fi
mkdir -p "$HOME/gdrive"
if ! mountpoint -q "$HOME/gdrive"; then
    (command -v rclone && rclone mount --read-only  gdrive: "$HOME/gdrive") &> /dev/null &
fi

[ -f "${HOME}/.bash_profile.local" ] && . "${HOME}/.bash_profile.local"

if [ -f "${HOME}/.START_SWAY" ]; then
    if [ $(tty) = /dev/tty1 ];then
        if  [ $(hostname) = "xmgneo" ];then
            exec sway --my-next-gpu-wont-be-nvidia
        else
            exec sway
        fi
    fi
fi
