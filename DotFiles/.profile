# Maintained in linux-init-files.org
logger -t "startup-initfile"  PROFILE

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


export PRINTER="EPSON_XP-820_Series"

export PROMPT_COMMAND='history -a'
export EDITOR='emacs-same-frame'
export VISUAL='emacs-same-frame'

export HISTSIZE=2056
export HISTCONTROL=ignoreboth:erasedups

export SHELL=/usr/bin/zsh

# export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig

export ARDUINO_SDK_PATH="${HOME}"/Dropbox/homefiles/development/arduino/arduinoSDK
export CMAKE_EXPORT_COMPILE_COMMANDS=1

export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"

alias man=eman

export PATH="${HOME}/bin:$HOME/.local/bin:${HOME}/.config/emacs/bin:${HOME}/.cargo/bin:./node_modules/.bin:$PATH"

export USER_STARTX_START=
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export USE_GPG_FOR_SSH="yes" # used in xsession

[[ -f  ~/.profile.local ]] && . ~/.profile.local