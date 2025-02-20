#!/usr/bin/env bash
# Maintained in linux-config.org
logger -t "startup-initfile"  BASH_PROFILE
[ -f ~/.profile ] && . ~/.profile || true
[ -f ~/.bashrc ] && . ~/.bashrc || true
#emacs --bg-daemon  &> /dev/null &

[ -f "${HOME}/.bash_profile.local" ] && . "${HOME}/.bash_profile.local"
[ -f "${HOME}/.cargo/env" ] && . "$HOME/.cargo/env"
sway-autostart
