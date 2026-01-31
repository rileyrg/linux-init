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

export DOT_PROFILE_SOURCED=1

export PRINTER="Canon_TR8500_series"

export PROMPT_COMMAND='history -a'

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -r"
# export EAT_SHELL_INTEGRATION_DIR="$HOME/.emacs.d/straight/build/eat/integration"


export HISTSIZE=2056
export HISTCONTROL=ignoreboth:erasedups

export HISTFILE=${XDG_CONFIG_HOME}/zsh/.zsh_history_$HOST

# export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig

export ARDUINO_SDK_PATH="${HOME}"/cloud/homefiles/development/arduino/arduinoSDK
export CMAKE_EXPORT_COMPILE_COMMANDS=1

export RIPGREP_CONFIG_PATH="${HOME}"/.ripgreprc

# OBS recording studio
# export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORM="xcb"

#alias man=eman

export PATH="${HOME}/bin":"${HOME}/bin/bin-nosync":"${HOME}/bin/sway":"${HOME}/.local/bin":"${HOME}/.emacs.d/bin":"${HOME}/.cargo/bin":"./node_modules/.bin":"${PATH}"

export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export USE_GPG_FOR_SSH="yes" # used in xsession

if [ -z "$XDG_CONFIG_HOME" ]
then
    export XDG_CONFIG_HOME="${HOME}/.config"
fi

# for sway waybar tray
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

export XCURSOR_SIZE=32
export XCURSOR_THEME=Adwaita

export GRIM_DEFAULT_DIR="${HOME}/tmp"

systemctl start --user mbsync.timer

#homebrew
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"

export FZF_TMUX_OPTS=1
export FZF_TMUX_OPTS="-d 40%"
export FZF_DEFAULT_COMMAND="fd -t f --follow --hidden --no-ignore-vcs"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d --follow --hidden --no-ignore-vcs"

# export BAT_POWER_SUSPEND_LEVEL=30
# export BAT_POWER_SUSPEND_POLL_CYCLE=300

if [ -z "$SSH_CONNECTION" ]; then
    (pgrep -f "discharge-suspend" > /dev/null ||  discharge-suspend &) 2>&1
fi

# export XKB_DEFAULT_LAYOUT=de
# export XKB_DEFAULT_OPTIONS=ctrl:nocaps

export PATH="${HOME}/bin/thirdparty/flutter/bin:$PATH"

export PATH="${HOME}"/bin/llvm:"${HOME}"/bin/llvm/build/bin:"$PATH"

export PURE_PYTHON=1

# haskell
#source "${HOME}/.ghcup/env"

export PYENV_ROOT="${HOME}/bin/thirdparty/pyenv"
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

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="/snap/bin:$PATH"

# platformio integration - point to pio ide (vscode) stuff.
export PATH="${PATH}:${HOME}/bin/thirdparty/stm32cubeide_1.9.0"

export USER_STARTX_START=

export CXX="/usr/bin/clang++"
# fix for java apps in sway
export _JAVA_AWT_WM_NONREPARENTING=1
[ -f "${HOME}/.profile.local" ] && . "${HOME}/.profile.local"
