# Maintained in linux-config.org
logger -t "startup-initfile"  PROFILE

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


export PRINTER="Canon_TR8500_series"

export PROMPT_COMMAND='history -a'

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c"

export HISTSIZE=2056
export HISTCONTROL=ignoreboth:erasedups

# export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig

export ARDUINO_SDK_PATH="${HOME}"/Dropbox/homefiles/development/arduino/arduinoSDK
export CMAKE_EXPORT_COMPILE_COMMANDS=1

export RIPGREP_CONFIG_PATH="${HOME}"/.ripgreprc

#alias man=eman

export PATH="${HOME}/bin":"${HOME}/bin/sway":"${HOME}/.local/bin":"${HOME}/.emacs.d/bin":"./node_modules/.bin":"${PATH}"

export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export USE_GPG_FOR_SSH="yes" # used in xsession

if [ -z "$XDG_CONFIG_HOME" ]
then
    export XDG_CONFIG_HOME="${HOME}/.config"
fi

# for sway waybar tray
export XDG_CURRENT_DESKTOP=Unity

[ -f "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"

#homebrew
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"

export FZF_TMUX_OPTS=1
export FZF_TMUX_OPTS="-d 40%"

export XKB_DEFAULT_LAYOUT=de
export XKB_DEFAULT_OPTIONS=ctrl:nocaps

export PATH="${HOME}/bin/thirdparty/flutter/bin:$PATH"

export PATH="${HOME}"/bin/llvm:"${HOME}"/bin/llvm/build/bin:"$PATH"

export PURE_PYTHON=1

# haskell
source "${HOME}/.ghcup/env"

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# platformio integration - point to pio ide (vscode) stuff.
export PATH="${PATH}:${HOME}/.platformio/penv/bin"

# android sdk
export ANDROID_HOME="${HOME}/development/Android/Sdk"
export PATH="${PATH}:${ANDROID_HOME}/emulator"
export PATH="${PATH}:${ANDROID_HOME}/platform-tools"

export ANDROID_STUDIO_HOME="${HOME}/bin/thirdparty/android-studio"
export PATH="${PATH}:${ANDROID_STUDIO_HOME}/bin"

export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# platformio integration - point to pio ide (vscode) stuff.
export PATH="${PATH}:${HOME}/bin/thirdparty/stm32cubeide_1.9.0"

export USER_STARTX_START=

# fix for java apps in sway
export _JAVA_AWT_WM_NONREPARENTING=1
[ -f "${HOME}/.profile.local" ] && . "${HOME}/.profile.local"
