# Introduction


## Status

Work in progress!! Keep all config and scripts in a single org file for documentation. Use org tangling for exporting them.


## GIT


### ~/.gitconfig

global git settings

```conf
# Maintained in linux-init-files.org
[user]
        name = Richard G. Riley
        email = rileyrg@gmx.de
[push]
        default = current
```


### master branch, no commit

```bash
#!/bin/sh
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "master" ]; then
  echo "You can't commit directly to master branch"
  exit 1
fi
```


# X Related

Manual setup files for startx. See <http://bhepple.com/doku/doku.php?id=starting_x>


## ~/

.xinitrc CLOSED: <span class="timestamp-wrapper"><span class="timestamp">[2020-12-20 So 13:35]</span></span>

I use this as a kind of placeholder to remind me that system xinitrc is doing the work.

```conf
#!/usr/bin/bash
# Maintained in linux-init-files.org
# Dont need that as startx will use xinitc anyway if this doesnt exist.
. /etc/X11/xinit/xinitrc

```


## ~/.xprofile

Another placeholder doing nothing as xinit launches XSession which uses .xsession and .xsessionrc on Debian

```bash
# Maintained in linux-init-files.org
# all moved to .xsessionrc so /etc/X11/Xsession loads it

```


## ~/.xsession

[/etc/X11/Xsession.d](file:///etc/X11) does the most work. It's processed by [startx](file:///usr/bin/startx)->[xinitrc](file:///etc/X11/xinit/xinitrc) which in turn calls [/etc/X11/Xsession](file:///etc/X11/Xsession)

```bash
#!/usr/bin/env bash
# Maintained in linux-init-files.org

logger -t "startup-initfile"  USER-XSESSION
exec dbus-launch --sh-syntax --exit-with-session i3
```


## ~/.xsessionrc


### DONE check that picom is started for all but x270


### processed by [XSession](file:///etc/X11/Xsession)

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
logger -t "startup-initfile"  XPROFILE
xhost +

xset s off
xset -dpms

export PRIMARY_DISPLAY="$(xrandr | awk '/ connected/{print $1}')"

# .xsessionrc.local for this type of thing
case "$(hostname)" in
    "thinkpadt460")
    # disable trackpad
    xinput set-prop $(xinput list --id-only "SynPS/2 Synaptics TouchPad") "Device Enabled" 0
    ;;
    "thinkpadx270")
    ;;
    "xmgneo")
    # xrandr --output eDP-1 --mode 2560x1440 --rate 165 #--scale 0.8x0.8
    # picom --backend glx --vsync &
    ;;
    *)
    # picom --backend glx --vsync &
    ;;
esac

[ -f "${HOME}"/.config/user-dirs.dir ] && . "${HOME}"/.config/user-dirs.dir || true
[ -f "${HOME}"/.xsessionrc.local ] && . "${HOME}"/.xsessionrc.local || true

xss-lock -- x-lock-utils lock &
x-idlehook &
(post-lock && post-blank) &
(sleep 2 && gpg-cache)&


```


## ~/.xsessionrc.local

Add machine specifics. The xmg neo 15 [keyboard backlight repo](https://github.com/pobrn/ite8291r3-ctl) for example.


### task

1.  DONE do I really need a local if we $HOSTNAME things? Think not. Keep it in the org master file.


### code

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
logger -t "startup-initfile"  XSESSIONRC-LOCAL
# sugestions for .xsessionrc.local
# export XIDLEHOOK_KBD=60
# export XIDLEHOOK_DIM=120
# export XIDLEHOOK_BLANK=600
# export XIDLEHOOK_LOCK=7200
# export XIDLEHOOK_SUSPEND=3600
xrandr --output "$PRIMARY_DISPLAY" --mode 1920x1080 --dpi 175
```


## ~/.Xresources

```conf
urxvt.font: xft:Monospace:pixelsize=14
#ifdef SRVR_thinkpadx270
urxvt.font: xft:Monospace:pixelsize=20
*i3font: pango:Monospace 20
#endif
#ifdef SRVR_thinkpadt460
urxvt.font: xft:Monospace:pixelsize=12
*i3font: pango:Monospace 12
#endif
! Fonts {{{
Xft.antialias: true
Xft.hinting:   true
Xft.rgba:      rgb
Xft.hintstyle: hintfull
Xft.dpi:       96
#ifdef SRVR_thinkpadt460
Xft.dpi:       84
#endif
#ifdef SRVR_thinkpadx270
Xft.dpi:       128
#endif
#ifdef SRVR_xmgneo
Xft.dpi:       144
#endif
! }}}

```


## ~/bin/x-lock-utils

Just a gathering place of locky/suspendy type things&#x2026;

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org

lock() {
    logger -t "x-lock-utils"  lock
    pre-lock
    #         i3lock -c 000000 -n
    xbacklight -set 5
    xset dpms 5 0 0
    i3lock -n -c 000000
    xset -dpms
    x-backlight-persist restore
    post-lock
}

lock_gpg_clear() {
    logger -t "x-lock-utils"  lock_gpg_clear
    [ "$1" = gpg_clear ] &&  (echo RELOADAGENT | gpg-connect-agent &>/dev/null )
    lock
}

case "$1" in
    lock)
        lock
        ;;
    lock_gpg_clear)
        lock_gpg_clear
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        lock
        ;;
esac

exit 0
```


## xidlehook for handling dim and pause prefs

See [xidlehook](https://github.com/jD91mZM2/xidlehook). Better handling of idle things. Dont dim or blank when watching a video or in full screen. [acpilight](https://gitlab.com/wavexx/acpilight ) provides a better xbacklight.\*


### TODO look into only time suspend if on battery


### ~/bin/x-idlehook

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
systemctl --user start  pulseaudio &> /dev/null || true

xidlehook \
    `# Don't lock when there's a fullscreen application` \
    --not-when-fullscreen \
    `# Don't lock when there's audio playing` \
    --not-when-audio \
    --timer ${XIDLEHOOK_KBD:-60}\
    'pre-blank' \
    'post-blank' \
    --timer ${XIDLEHOOK_DIM:-120}\
    'xbacklight -set 5' \
    'post-blank' \
    --timer ${XIDLEHOOK_BLANK:-240}\
    'xbacklight -set 0' \
    'post-blank' \
    --timer ${XIDLEHOOK_LOCK:-300}\
    '(pre-lock && x-lock-utils lock)' \
    '(post-blank && post-lock)' \
    --timer ${XIDLEHOOK_SUSPEND:-3600}\
    'systemctl suspend' \
    ''
```


## ~/bin/rnv

enable force of nvidia driver - run with nvidia

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia ${@}
```


## ~/bin/display-id

get id of primary display

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
xrandr -q | grep " connected " | cut -d' ' -f1 | head -n 1
```


## ~/bin/x-backlight-persist

Save and restore backlight values

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org

save() {
    l=$(xbacklight -get);
    echo  $l > ~/.x-backlight-persist
    echo $l
}

get() {
    echo $(xbacklight -get);
}

restore() {
    b=100
    [ -f ~/.x-backlight-persist ] && read b < ~/.x-backlight-persist
    xbacklight -set $b
    echo $b
}

case "$1" in
    save)
        save
        [ -n "$2" ] && xbacklight -set "$2"
        ;;
    restore)
        restore
        ;;
    get)
        get
        ;;
    *)
        save
        ;;
esac

exit 0

```


## ~/bin/xmg-dual-screens


### background

It's worth looking into using [arandr](https://christian.amsuess.com/tools/arandr/) for using the somewhat complex xrandr command. This link is very helpful: [What does “sink output, source output, sink offload, source offload” mean for GPUs?](https://superuser.com/questions/861530/what-does-sink-output-source-output-sink-offload-source-offload-mean-for-gp)


### code

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
on=$([ "$1" = "on" ] && echo "on" || echo "off")
hires=$([ "$2" = "on" ] && echo "on" || echo "off")
hires_mode=$([ "$hires" = "on" ] && echo "--mode 3840x2160 --rate 30" || echo "--mode 1920x1080 --rate 60")

xrandr --setprovideroutputsource 1 0

xrandr --output eDP-1 $( [ ! "$on" = "on" ] && echo "--primary") --pos 0x0 --rotate normal  --mode 2560x1440 --rate 165
xrandr --output HDMI-1-0  $( [ "$on" = "on" ] && echo "--right-of eDP-1 --primary "$hires_mode"" || echo "--off" )

echo "Dual Screens $([ "$on" = "on" ] && echo -n "on, hires:"$hires"" || echo "off")"
```


### testing

1.  dual screens off

    ```bash
    xmg-dual-screens off
    ```

2.  dual screens on low res

    ```bash
    xmg-dual-screens on
    ```

3.  dual screens on hi res

    ```bash
    xmg-dual-screens on on
    ```


## Xorg


### XMG Neo 15

Using an Itel iGPU and an NVIDIA 2070 super dGPU , boot using hybrid mode.

1.  install nvidia driver.

    ```bash
    sudo -S apt install nvidia-driver nvidia-settings
    ```

2.  Running Games/Apps using the dGPU

    Use the prefix method on Debian Bullseye after installing the Nividia driver.

    1.  command line

        ```bash
        __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia my_gfx-game
        ```

    2.  Steam

        In short, effectively do what we did above but using the "launch options" for the game in Question. For all games where you want the dGPU used, make the following the "launch options" entry

        ```bash
        __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
        ```

    3.  xorg.conf

        1.  tasks

            1.  DONE creatging an/etc/X11/xorg.conf

        2.  xmgneo xorg.conf

            Having an xorg.conf seems to help. It solved tearing issues for me. BUT the the I had all sorts of focus issues. You don't need an xorg.conf. You do need a compositor with vsync. Left here for posterity.

            ```conf
            # Maintained in linux-init-files.org
            Section "ServerLayout"
            Identifier "layout"
            Screen 0 "intel"
            Screen 1 "nvidia"
            EndSection

            Section "Device"
            Identifier "intel"
            Driver "intel"
            BusID "PCI:0@00:02:0"
            #Option "AccelMethod" "SNA"
            EndSection

            Section "Screen"
            Identifier "intel"
            Device "intel"
            EndSection

            Section "Device"
            Identifier "nvidia"
            Driver "nvidia"
            BusID "PCI:0@01:00:0"
            Option "ConstrainCursor" "off"
            Option  "ForceFullCompositionPipeline" "on"
            EndSection

            Section "Screen"
            Identifier "nvidia"
            Device "nvidia"
            Option "AllowEmptyInitialConfiguration" "on"
            Option "IgnoreDisplayDevices" "CRT"
            EndSection

            ```


## Compton Compositor


### DONE Important - replaced by PICOM

[Compton](https://github.com/chjj/compton) is a compositor for X, and a fork of xcompmgr-dana


### ~/.config/compton/compton.conf

```conf
backend = "xrender";
vsync = true;

shadow = true;
shadow-radius = 10;
shadow-offset-x = -5;
shadow-offset-y = 0;
shadow-opacity = 0.8;
shadow-red = 0.11;
shadow-green = 0.12;
shadow-blue = 0.13;
shadow-exclude = [
"name = 'Notification'",
"_GTK_FRAME_EXTENTS@:c",
"class_g = 'i3-frame'",
"_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'",
"_NET_WM_STATE@:32a *= '_NET_WM_STATE_STICKY'",
"!I3_FLOATING_WINDOW@:c"
];
shadow-ignore-shaped = true;

blur-background = false;
blur-background-fixed = true;
blur-kern = "7x7box";
blur-background-exclude = [
"class_g = 'i3-frame'",
"window_type = 'dock'",
"window_type = 'desktop'",
"_GTK_FRAME_EXTENTS@:c"
];

# Duplicating the _NET_WM_STATE entries because compton cannot deal with atom arrays :-/
opacity-rule = [
"97:class_g = 'Termite' && !_NET_WM_STATE@:32a",

"0:_NET_WM_STATE@[0]:32a = '_NET_WM_STATE_HIDDEN'",
"0:_NET_WM_STATE@[1]:32a = '_NET_WM_STATE_HIDDEN'",
"0:_NET_WM_STATE@[2]:32a = '_NET_WM_STATE_HIDDEN'",
"0:_NET_WM_STATE@[3]:32a = '_NET_WM_STATE_HIDDEN'",
"0:_NET_WM_STATE@[4]:32a = '_NET_WM_STATE_HIDDEN'",

"90:_NET_WM_STATE@[0]:32a = '_NET_WM_STATE_STICKY'",
"90:_NET_WM_STATE@[1]:32a = '_NET_WM_STATE_STICKY'",
"90:_NET_WM_STATE@[2]:32a = '_NET_WM_STATE_STICKY'",
"90:_NET_WM_STATE@[3]:32a = '_NET_WM_STATE_STICKY'",
"90:_NET_WM_STATE@[4]:32a = '_NET_WM_STATE_STICKY'"
];

fading = false;
fade-delta = 7;
fade-in-step = 0.05;
fade-out-step = 0.05;
fade-exclude = [];

mark-wmwin-focused = true;
mark-ovredir-focused = true;
use-ewmh-active-win = true;
detect-rounded-corners = true;
detect-client-opacity = true;
refresh-rate = 0;
dbe = false;
glx-no-stencil = true;
glx-copy-from-front = false;
unredir-if-possible = false;
focus-exclude = [];
detect-transient = true;
detect-client-leader = true;
invert-color-include = [];

wintypes: {
tooltip = { fade = true; shadow = false; opacity = 1.00; focus = true; };
dock = { shadow = false };
dnd = { shadow = false };
};
```


## Picom compositor

[Picom](https://github.com/yshui/picom) is the successor to compton. Start this in your xsessionrc for example:-

```bash
#!/usr/bin/bash
picom --backend glx --vsync &
```


# TODO PAM Environment

Ended up giving up on this. PAM is a configuration nightmare.

This IS working with startx but not with gdm3 i3


## ~/.pam\_environment

```conf
# Maintained in linux-init-files.org
# PATH           DEFAULT=@{HOME}/bin:@{HOME}/.local/bin:@{HOME}/.cargo/bin:/usr/local/bin:/bin:/usr/bin:/usr/games:/usr/local/bin/X11:/usr/bin/X11
```


# User system services


### gpg-agent

If using startx on debian this is taken care of by the system XSession loading everyhing in /etc/X11/Xsession.d. see [/usr/share/doc/gnupg/examples](file:///usr/share/doc/gnupg/examples)


# Bash related


## ~/.profile

```bash
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

export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export USE_GPG_FOR_SSH="yes" # used in xsession

if [ -z "$XDG_CONFIG_HOME" ]
then
    export XDG_CONFIG_HOME="$HOME/.config"
fi


[ -f ~/.bash_profile.local ] && . ~/.bash_profile.local

```


## ~/.bash\_profile

```bash
# Maintained in linux-init-files.org
logger -t "startup-initfile"  BASH_PROFILE

[ -f ~/.profile ] && . ~/.profile || true
[ -f ~/.bashrc ] && . ~/.bashrc || true

post-lock
## this bit sucks. start mbsync,time manually if enrypted homedir else it doesnt work
systemctl is-active --user mbsync.timer || systemctl --user start mbsync.timer
dropbox-start-once async
fortune | cowsay
```


## ~/.bashrc

```bash
# Maintained in linux-init-files.org
logger -t "startup-initfile"  BASHRC
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    dumb) color_prompt=no;;
    xterm-256color) color_prompt=no;;
    *) color_prompt=no
       ;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=no
    fi
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

stty -ixon

GPG_TTY=$(tty)
export GPG_TTY

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

```


# ZSH Related


## ~/.config/zsh/.zshrc

```bash
# Maintained in linux-init-files.org
logger -t "startup-initfile"  ZSHRC
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
export TERM="xterm-256color"
# Path to your oh-my-zsh installation.
export ZSH="${XDG_CONFIG_HOME}/zsh/oh-my-zsh"

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    ZSH_TMUX_AUTOSTART=false
else
    ZSH_TMUX_AUTOSTART=true
fi

# turn off auto tmux start
ZSH_TMUX_AUTOSTART=false

ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_AUTOCONNECT=true
ZSH_TMUX_AUTOQUIT=true

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

# POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_MODE='awesome-fontconfig'
ZSH_THEME="powerlevel9k/powerlevel9k"

# ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    zsh-autosuggestions
    dotenv
    vi-mode
    tmux
    colored-man-pages
    git
    zsh-syntax-highlighting
)
HISTFILE=${XDG_CONFIG_HOME}/zsh/.zsh_history_$HOST

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_BEEP


source $ZSH/oh-my-zsh.sh

# User configuration
setopt extended_glob
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# GREP_OPTIONS="--color=never"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
# DEFAULT_USER means we dont show user and host in normal shell prompt
DEFAULT_USER=$USER

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fortune | cowsay
```


## ~/.config/zsh/.zlogin

```bash
# Maintained in linux-init-files.org
logger -t "startup-initfile"  ZLOGIN
# [ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
```


## zprofile

1.  ~/.config/zsh/.zprofile

    ```bash
    # Maintained in linux-init-files.org
    logger -t "startup-initfile"  ZPROFILE
    if [ -f ~/.profile ]; then
        emulate sh -c '. ~/.profile'
    fi
    ```

2.  etc/zsh/zprofile

    ```bash
    # Maintained in linux-init-files.org
    # /etc/zsh/zprofile: system-wide .zprofile file for zsh(1).
    #
    # This file is sourced only for login shells (i.e. shells
    # invoked with "-" as the first character of argv[0], and
    # shells invoked with the -l flag.)
    #
    # Global Order: zshenv, zprofile, zshrc, zlogin
    logger -t "startup-initfile"  ETC-ZPROFILE
    ```


## zshenv

1.  etc/zsh/zshenv

    ```bash
    # Maintained in linux-init-files.org
    logger -t "startup-initfile"  ETC-ZSHENV
    if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]
    then
        export PATH="/usr/local/bin:/usr/bin:/bin:/usr/games"
        if [ -f /etc/profile ]; then
            emulate sh -c '. /etc/profile'
        fi
    fi
    ```

2.  ~/.config/zsh/.zshenv

    Link this into $HOME

    ```bash
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
    ```


## Oh-My-Zsh Related

Directory is [here](.oh-my-zsh/).

1.  Aliases ~/.config/zsh/oh-my-zsh/custom/aliases.zsh

    ```conf
    # Maintained in linux-init-files.org
    alias grep="grep -n --color"
    alias hg='history|grep'
    ```

2.  Functions ~/.config/zsh/oh-my-zsh/custom/functions.zsh

    ```bash
    mkc () {
        mkdir -p "$@" && cd "$@" #create full path and cd to it

    }
    ```


# Path


## ~/bin/add-user-paths

```bash
# Maintained in linux-init-files.org
logger -t "startup-initfile"  ADD_USER_PATHS
#export PATH="${HOME}/bin:$HOME/.local/bin:${HOME}/.cargo/bin:./node_modules/.bin:$PATH"
```


# Tmux Related


## ~/.tmux.conf

```conf
# Maintained in linux-init-files.org
# Example .tmux.conf
#
# By Nicholas Marriott. Public domain.
#

# Some tweaks to the status line
set -g status-right "%H:%M"
set -g window-status-current-style "underscore"

# If running inside tmux ($TMUX is set), then change the status line to red
%if #{TMUX}
set -g status-bg red
%endif

# Enable RGB colour if running in xterm(1)
set-option -sa terminal-overrides ",xterm*:Tc"

# Change the default $TERM to tmux-256color
set -g default-terminal "tmux-256color"

# No bells at all
set -g bell-action none

# Keep windows around after they exit
set -g remain-on-exit off

# Change the prefix key to C-a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# reload tmux config
bind r source-file ~/.tmux.conf \; display-message "Config reloaded..."

# # Linux only
# set -g mouse on
# bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
# bind -n WheelDownPane select-pane -t= \; send-keys -M
# bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
# bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
# bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
# bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
# bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

# To copy, left click and drag to highlight text in yellow,
# once you release left click yellow text will disappear and will automatically be available in clibboard
# # Use vim keybindings in copy mode
setw -g mode-keys vi

bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"
bind -T copy-mode-vi C-j send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"

# Some extra key bindings to select higher numbered windows
bind F1 selectw -t:10
bind F2 selectw -t:11
bind F3 selectw -t:12
bind F4 selectw -t:13
bind F5 selectw -t:14
bind F6 selectw -t:15
bind F7 selectw -t:16
bind F8 selectw -t:17
bind F9 selectw -t:18
bind F10 selectw -t:19
bind F11 selectw -t:20
bind F12 selectw -t:21

# A key to toggle between smallest and largest sizes if a window is visible in
# multiple places
bind F set -w window-size

# Keys to toggle monitoring activity in a window and the synchronize-panes option
bind m set monitor-activity
bind y set synchronize-panes\; display 'synchronize-panes #{?synchronize-panes,on,off}'

new -d -s0
# neww -d -nemacs 'exec emacsclient -nw ~/.emacs.d/linux-init/inits.org'
# setw -t0:1 aggressive-resize on
# neww -d  -nhtop 'exec htop'

set -g mouse on
set -g @yank_selection 'clipboard' # 'primary' or 'secondary' or 'clipboard'
set -g @yank_selection_mouse 'clipboard' # or 'primary' or 'secondary'
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-yank'

run -b '~/.tmux/plugins/tpm/tpm'

```


# I3 window manager


## ~/.config/i3/config

```conf
# Maintained in linux-init-files.org
# This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see https://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4

# Font  for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
#font pango:monospace 12
# font pango:JetBrains Mono 16

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
font pango:DejaVu Sans Mono 16
set_from_resource $i3font i3wm.i3font pango:Monospace 10font $i3font
font $i3font
# The combination of xss-lock, nm-applet and pactl is a popular choice, so
# they are included here as an example. Modify as you see fit.

# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
# ***moved to xprofile
# exec --no-startup-id xss-lock --transfer-sleep-lock -- x-lock-utils lock
# NetworkManager is the most popular way to manage wireless networks on Linux,
# and nm-applet is a desktop environment-independent system tray GUI for it.
# ***moved to xprofile
# exec --no-startup-id nm-applet

# Use pactl to adjust volume in PulseAudio.
#       set $refresh_i3status killall -SIGUSR1 i3status
set $refresh_i3status killall -SIGUSR1 py3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# workspace_layout <default|stacking|tabbed>
workspace_layout default

# start a terminal
#bindsym $mod+Return exec i3-sensible-terminal
bindsym --release $mod+Return exec "oneterminal"

# kill focused window
bindsym $mod+q kill

# start dmenu (a program launcher)
# bindsym $mod+d exec dmenu_run
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+odiaeresis focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+odiaeresis move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1:edit"
set $ws2 "2:research"
set $ws3 "3:shell"
set $ws4 "4:browse"
set $ws5 "5:dired"
set $ws6 "6:music"
set $ws7 "7:video"
set $ws8 "8:irc"
set $ws9 "9:steam"
set $ws10 "10"

# switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
# bindsym $mod+Control+q exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
# These bindings trigger as soon as you enter the resize mode

# Pressing left will shrink the window’s width.
# Pressing right will grow the window’s width.
# Pressing up will shrink the window’s height.
# Pressing down will grow the window’s height.
bindsym j resize shrink width 10 px or 10 ppt
bindsym k resize grow height 10 px or 10 ppt
bindsym l resize shrink height 10 px or 10 ppt
bindsym odiaeresis resize grow width 10 px or 10 ppt

# same bindings, but for the arrow keys
bindsym Left resize shrink width 10 px or 10 ppt
bindsym Down resize grow height 10 px or 10 ppt
bindsym Up resize shrink height 10 px or 10 ppt
bindsym Right resize grow width 10 px or 10 ppt

# back to normal: Enter or Escape or $mod+r
bindsym Return mode "default"
bindsym Escape mode "default"
bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

# i3bar
bar {
status_command i3blocks
font pango:JetBrains Mono 10
position top
#mode hide
hidden_state hide
modifier $mod
}

#general user launch bindings
bindsym $mod+Shift+e exec emacs-same-frame
bindsym $mod+Shift+f exec google-chrome --disable-session-crashed-bubble
bindsym $mod+Control+t exec "notify-send -t 2000 'Opening NEW Terminator instance' && terminator -e tmux"
bindsym $mod+Control+l exec (sleep 1 && xset dpms force off) #triggers xss-lock
bindsym $mod+Control+o exec xmg-neo-rgb-kbd-lights toggle && x-backlight-persist restore
bindsym $mod+Control+g exec x-lock-utils lock_gpg_clear
bindsym $mod+Control+f exec thunar
bindsym $mod+Control+s exec signal-desktop
bindsym $mod+Control+d exec emacsclient -c -eval '(dired "~")'
bindsym $mod+g exec "goldendict \\"`xclip -o -selection clipboard`\\""
bindsym $mod+Control+p exec onehtop
bindsym $mod+Control+c exec conky
bindsym $mod+Shift+s sticky toggle
bindsym Print exec gnome-screenshot
bindsym Shift+Print exec gnome-screenshot -a

bindsym $mod+Tab workspace back_and_forth

exec --no-startup-id feh --image-bg black  --bg-fill ~/Pictures/Wallpapers/current
exec --no-startup-id nm-applet

# non desktop specific so start in xsessionrc
# exec --no-startup-id command -v dropbox &> /dev/null &&  dropbox start &> /dev/null
# exec --no-startup-id command -v steam &> /dev/null && steam -silent &> /dev/null


#rofi instead of dmenu
bindsym $mod+d exec --no-startup-id "rofi -show drun -font \\"DejaVu 9\\" -run-shell-command '{terminal} -e \\" {cmd}; read -n 1 -s\\"'"

set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown
mode "$mode_system" {
bindsym l exec --no-startup-id x-lock-utils lock, mode "default"

bindsym e exec --no-startup-id x-lock-utils logout, mode "default"
bindsym s exec --no-startup-id x-lock-utils suspend, mode "default"
bindsym h exec --no-startup-id x-lock-utils hibernate, mode "default"
bindsym r exec --no-startup-id x-lock-utils reboot, mode "default"
bindsym Shift+s exec --no-startup-id x-lock-utils shutdown, mode "default"
# back to normal: Enter or Escape
bindsym Return mode "default"
bindsym Escape mode "default"
}

bindsym $mod+Control+q mode "$mode_system"

bindsym XF86MonBrightnessUp exec --no-startup-id xbacklight -inc 10 && x-backlight-persist save && post-blank

bindsym XF86MonBrightnessDown exec --no-startup-id xbacklight -dec 10 && x-backlight-persist save

#set wallpaper
### i3-gaps stuff ###

# Necessary for i3-gaps to work properly (pixel can be any value)
for_window [class="^.*"] border pixel 3

# Smart Gaps
smart_gaps on

# Smart Borders
smart_borders on

# Set inner/outer gaps
gaps inner 14
gaps outer 0

# Gaps mode
set $mode_gaps Gaps: (o)uter, (i)nner, (h)orizontal, (v)ertical, (t)op, (r)ight, (b)ottom, (l)eft
set $mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_horiz Horizontal Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_verti Vertical Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_top Top Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_right Right Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_bottom Bottom Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_left Left Gaps: +|-|0 (local), Shift + +|-|0 (global)
bindsym $mod+Shift+g mode "$mode_gaps"

mode "$mode_gaps" {
bindsym o      mode "$mode_gaps_outer"
bindsym i      mode "$mode_gaps_inner"
bindsym h      mode "$mode_gaps_horiz"
bindsym v      mode "$mode_gaps_verti"
bindsym t      mode "$mode_gaps_top"
bindsym r      mode "$mode_gaps_right"
bindsym b      mode "$mode_gaps_bottom"
bindsym l      mode "$mode_gaps_left"
bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}

mode "$mode_gaps_outer" {
bindsym plus  gaps outer current plus 5
bindsym minus gaps outer current minus 5
bindsym 0     gaps outer current set 0

bindsym Shift+plus  gaps outer all plus 5
bindsym Shift+minus gaps outer all minus 5
bindsym Shift+0     gaps outer all set 0

bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}
mode "$mode_gaps_inner" {
bindsym plus  gaps inner current plus 5
bindsym minus gaps inner current minus 5
bindsym 0     gaps inner current set 0

bindsym Shift+plus  gaps inner all plus 5
bindsym Shift+minus gaps inner all minus 5
bindsym Shift+0     gaps inner all set 0

bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}
mode "$mode_gaps_horiz" {
bindsym plus  gaps horizontal current plus 5
bindsym minus gaps horizontal current minus 5
bindsym 0     gaps horizontal current set 0

bindsym Shift+plus  gaps horizontal all plus 5
bindsym Shift+minus gaps horizontal all minus 5
bindsym Shift+0     gaps horizontal all set 0

bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}
mode "$mode_gaps_verti" {
bindsym plus  gaps vertical current plus 5
bindsym minus gaps vertical current minus 5
bindsym 0     gaps vertical current set 0

bindsym Shift+plus  gaps vertical all plus 5
bindsym Shift+minus gaps vertical all minus 5
bindsym Shift+0     gaps vertical all set 0

bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}
mode "$mode_gaps_top" {
bindsym plus  gaps top current plus 5
bindsym minus gaps top current minus 5
bindsym 0     gaps top current set 0

bindsym Shift+plus  gaps top all plus 5
bindsym Shift+minus gaps top all minus 5
bindsym Shift+0     gaps top all set 0

bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}
mode "$mode_gaps_right" {
bindsym plus  gaps right current plus 5
bindsym minus gaps right current minus 5
bindsym 0     gaps right current set 0

bindsym Shift+plus  gaps right all plus 5
bindsym Shift+minus gaps right all minus 5
bindsym Shift+0     gaps right all set 0

bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}
mode "$mode_gaps_bottom" {
bindsym plus  gaps bottom current plus 5
bindsym minus gaps bottom current minus 5
bindsym 0     gaps bottom current set 0

bindsym Shift+plus  gaps bottom all plus 5
bindsym Shift+minus gaps bottom all minus 5
bindsym Shift+0     gaps bottom all set 0

bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}
mode "$mode_gaps_left" {
bindsym plus  gaps left current plus 5
bindsym minus gaps left current minus 5
bindsym 0     gaps left current set 0

bindsym Shift+plus  gaps left all plus 5
bindsym Shift+minus gaps left all minus 5
bindsym Shift+0     gaps left all set 0

bindsym Return mode "$mode_gaps"
bindsym Escape mode "default"
}
```


## ~/.config/i3blocks/config

```conf
# Guess the weather hourly
[dropbox]
interval=15
command=echo  "$(my-i3b-db-status)"
color=#1010E0

[weather]
command=curl -Ss 'https://wttr.in?0&T&Q' | cut -c 16- | head -2 | xargs echo

interval=900
color=#A4C2F4

[battery]
command=echo "$(my-i3b-battery-status)"
interval=60
color=#b01010

# [disk]
# command=echo "D:$(/usr/share/i3blocks/disk)"
# interval=600
# color=#003000

# [memory]
# command=echo "M:$(/usr/share/i3blocks/memory)"
# interval=30
# color=#003000

[uptime]
command=uptime -p
interval=300
color=#505050

[ssid]
command=echo "SSID:$(my-iface-active-ssid)"
interval=30
color=#00a000

[ssidQ]
command=echo "($(my-iface-active-quality)%)"
interval=30
color=#008000

[ipaddr]
command=echo "@$(my-iface-active-ipaddr)"
interval=30
color=#009000

[time]
command=date +"%d/%m/%Y %H:%M"
interval=60
color=#e2b007

[volume]
command=echo "V:$(/usr/share/i3blocks/volume)"
interval=5
color=#303030

```


## ~/bin/i3pulse

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
if pgrep -x "pulseaudio" >/dev/null
then
    echo "pulseaudio started so kill"
    pulseaudio -k && sleep 2
fi
echo "starting pulseaudio daemon"
(pulseaudio -D && sleep 5) || true
```


# Vim


## ~/.vimrc

```conf
" Maintained in linux-init-files.org
set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-scripts/mru.vim'
" Plug 'ervandew/supertab'

call plug#end()

set nonu nu ic is hls

map ; :Files<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

cnoreabbrev <expr> tn getcmdtype() == ":" && getcmdline() == 'tn' ? 'tabnew' : 'tn'
cnoreabbrev <expr> th getcmdtype() == ":" && getcmdline() == 'th' ? 'tabp' : 'th'
cnoreabbrev <expr> tl getcmdtype() == ":" && getcmdline() == 'tl' ? 'tabn' : 'tl'
cnoreabbrev <expr> te getcmdtype() == ":" && getcmdline() == 'te' ? 'tabedit' : 'te'

nnoremap <F5> :buffers<CR>:buffer<Space>

map <C-o> :NERDTreeToggle<CR>

set shortmess+=A
set splitbelow
set splitright

```


# ripgrep


## ~/.ripgreprc

```conf

# Maintained in linux-init-files.org
# Don't let ripgrep vomit really long lines to my terminal, and show a preview.
--max-columns=150

# Add my 'web' type.
--type-add
web:*.{html,css,js}*

# Using glob patterns to include/exclude files or folders
--glob=!git/*

# or
--glob
!git/*
--glob
!*.md
--glob
!*.*~

# Set the colors.
--color=never
--colors=line:none
--colors=line:style:bold

# Because who cares about case!?
--smart-case
```


# Conky


## ~/.config/conky/conky.conf

```conky
--[[
Conky, a system monitor, based on torsmo

Any original torsmo code is licensed under the BSD license

All code written since the fork of torsmo is licensed under the GPL

Please see COPYING for details

Copyright (c) 2004, Hannu Saransaari and Lauri Hakkarainen
Copyright (c) 2005-2019 Brenden Matthews, Philip Kovacs, et. al. (see AUTHORS)
All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

conky.config = {
    alignment = 'top_left',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=12',
    gap_x = 60,
    gap_y = 60,
    minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'desktop',
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
}

conky.text = [[
${color grey}Info:$color ${scroll 32 Conky $conky_version - $sysname $nodename $kernel $machine}
$hr
${color grey}Uptime:$color $uptime
${color grey}Frequency (in MHz):$color $freq
${color grey}Frequency (in GHz):$color $freq_g
${color grey}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color grey}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color grey}CPU Usage:$color $cpu% ${cpubar 4}
${color grey}Processes:$color $processes  ${color grey}Running:$color $running_processes
$hr
${color grey}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
${color grey}Networking:
Up:$color ${upspeed} ${color grey} - Down:$color ${downspeed}
$hr
${color grey}Name              PID     CPU%   MEM%
${color lightgrey} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey} ${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
]]
```


# Radare

Reverse engineering packges [radare2](https://radare.gitbooks.io/radare2book/content/first_steps/intro.html).


## ~/.config/radare2/radare2rc

```conf
e scr.utf8=true
e scr.utf8.curvy=true
e dbg.bep=main
```


# GDB


## ~/.gdbinit

```conf
# Maintained in linux-init-files.org
alias gef = source ~/bin/thirdparty/gef/gef.py

set auto-load safe-path /
set auto-load local-gdbinit on

set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on
```


# PGP/GNUPG/GPG


## ~/.gnupg/gpg.conf

```gpg
# Maintained in linux-init-files.org
use-agent
```


## ~/.gnupg/gpg-agent.conf

```conf
# Maintained in linux-init-files.org
#gpg-preset-passphrase
allow-preset-passphrase
pinentry-program /usr/bin/pinentry
max-cache-ttl 86400
default-cache-ttl 86400
max-cache-ttl-ssh 86400
default-cache-ttl-ssh 86400
enable-ssh-support
```


## ~/.profile

```bash
export USER_STARTX_START=
```


# systemd


## DONE lock when lid closed


### ~/.config/systemd/user/lidlock.service

```conf
# Maintained in linux-init-files.org
[Unit]
Description=i3lock on suspend
After=sleep.target

[Service]
Type=forking
Environment=DISPLAY=:0
#ExecStart=/usr/bin/i3lock -d -c 000000

[Install]
WantedBy=sleep.target
```


# ACPI


## power status


### acpid events

You must copy these into [*etc/acpi/events*](file:///etc/acpi/events/) if you have an encrypted home directory else symlink.

1.  /etc/acpi/events/user-powerstate

    ```conf
    # Maintained in linux-init-files.org
    # /etc/acpi/events/user-powerstate
    # Called when the user connects ac power to us
    #
    event=ac_adapter.*
    action=/etc/acpi/actions/user-powerstate.sh
    ```

2.  /etc/acpi/events/xmg-neo-powerstate

    ```conf
    # Maintained in linux-init-files.org
    # /etc/acpi/events/xmg-neo-powerstate
    # Called when the user connects ac power to us
    #
    event=ac_adapter.*
    action=/etc/acpi/actions/xmg-neo-powerstate.sh
    ```


### acpid actions

You must copy these into [/etc/acpi/actions](file:///etc/acpi/actions) if you have an encrypted home directory else symlink.

1.  /etc/acpi/actions/user-powerstate.sh

    ```bash
    #!/usr/bin/bash
    # Maintained in linux-init-files.org
    # /etc/acpi/actions/user-powerstate
    . /usr/share/acpi-support/power-funcs
    . /usr/share/acpi-support/policy-funcs
    getState
    echo "export POWERSTATE=${STATE}"  > /tmp/user-acpi-powerstate
    export POWERSTATE=$STATE
    ```

2.  /etc/acpi/actions/xmg-neo-powerstate.sh

    ```bash
    #!/usr/bin/bash
    # Maintained in linux-init-files.org
    # /etc/acpi/actions/xmg-neo-powerstate
    . /usr/share/acpi-support/power-funcs
    . /usr/share/acpi-support/policy-funcs
    getState
    echo $( [ $STATE ="AC" ] && echo 0 || echo 1 ) > /sys/class/leds/qc71_laptop::lightbar/brightness

    ```

    remembering to restart acpid :

    ```bash
    sudo systemctl restart acpid
    ```


# Email Related


## mu4e  - mu for Emacs

[mu4e](https://www.djcbsoftware.nl/code/mu/mu4e.html), a Maildir based email client for Emacs, is configured in my [emacs-config](https://github.com/rileyrg/Emacs-Customisations)


## Maildir sync using [mbsync](https://wiki.archlinux.org/index.php/Isync) inspired by the [SystemCrafters](https://www.youtube.com/watch?v=yZRyEhi4y44&ab_channel=SystemCrafters&loop=0) video.

maildir sync using mbsync


### install isync and mu4e

mu4e includes [mu](https://www.djcbsoftware.nl/code/mu/mu4e/Indexing-your-messages.html) for indexing.

```bash
sudo apt install isync mu4e
```


### mbsync config

Note the [PassCmd](https://wiki.archlinux.org/index.php/Isync) - since I use gpg then that's the way to go.

```conf
# Maintained in linux-init-files.org
Create  Both
Expunge Both
SyncState *

IMAPAccount gmx
Host imap.gmx.com
User rileyrg@gmx.de
PassCmd "pass Email/gmx/apps/mbsync"
SSLType IMAPS
CertificateFile /etc/ssl/certs/ca-certificates.crt
PipelineDepth 1

IMAPStore gmx-remote
Account gmx

MaildirStore gmx-local
Path ~/Maildir/gmx/
Inbox ~/Maildir/gmx/INBOX
SubFolders Legacy

Channel gmx-inbox
Master :gmx-remote:"INBOX"
Slave :gmx-local:"INBOX"

Channel gmx-sent
Master :gmx-remote:"Gesendet"
Slave :gmx-local:"Sent"

Channel gmx-learning
Master :gmx-remote:"Learning"
Slave :gmx-local:"Learning"

Channel gmx-drafts
Master :gmx-remote:"Entw&APw-rfe"
Slave :gmx-local:"Drafts"

Channel gmx-bin
Master :gmx-remote:"Gel&APY-scht"
Slave :gmx-local:"Bin"

Channel gmx-spam
Master :gmx-remote:"Spamverdacht"
Slave :gmx-local:"Spam"

Channel gmx-archive
Master :gmx-remote:"Archiv"
Slave :gmx-local:"Archive"

Group gmx
Channel gmx-inbox
Channel gmx-sent
Channel gmx-drafts
Channel gmx-bin
Channel gmx-spam
Channel gmx-archive

Group gmx-special-interest
Channel gmx-learning

IMAPAccount gmail
Host imap.gmail.com
User rileyrg@gmail.com
PassCmd "pass Email/gmail/apps/mbsync"
SSLType IMAPS
CertificateFile /etc/ssl/certs/ca-certificates.crt
PipelineDepth 32

IMAPStore gmail-remote
Account gmail

MaildirStore gmail-local
Path ~/Maildir/gmail/
Inbox ~/Maildir/gmail/INBOX
SubFolders Legacy

Channel gmail-inbox
Master :gmail-remote:"INBOX"
Slave :gmail-local:"INBOX"

Channel gmail-sent
Master :gmail-remote:"[Google Mail]/Sent Mail"
Slave :gmail-local:"Sent"

Channel gmail-drafts
Master :gmail-remote:"[Google Mail]/Drafts"
Slave :gmail-local:"Drafts"

Channel gmail-bin
Master :gmail-remote:"[Google Mail]/Bin"
Slave :gmail-local:"Bin"

Channel gmail-spam
Master :gmail-remote:"[Google Mail]/Spam"
Slave :gmail-local:"Spam"

Channel gmail-archive
Master :gmail-remote:"[Google Mail]/All Mail"
Slave :gmail-local:"Archive"

Channel gmail-gmx-archive
Master :gmail-remote:"[Google Mail]/All Mail"
Slave :gmx-local:"gmail/Archive"

Group gmail
Channel gmail-inbox
Channel gmail-sent
Channel gmail-drafts
Channel gmail-bin
Channel gmail-spam
Channel gmail-archive

Group gmail-gmx
Channel gmail-gmx-archive

```


### sync and index

```bash
cd ~
mkdir -p ~/Maildir/gmail
mkdir -p ~/Maildir/gmx
mbsync gmail gmx
mu init --maildir=~/Maildir --my-address="riley**@gmx.de" --my-address="riley**@gmail.com"
mu index
```


### mbsync services

1.  ~/.config/systemd/user/mbsync.timer

    ```conf
    [Unit]
    Description=Mailbox synchronization timer

    [Timer]
    OnBootSec=15m
    OnUnitActiveSec=60m
    Unit=mbsync.service

    [Install]
    WantedBy=timers.target
    ```

2.  ~/.config/systemd/user/mbsync.service

    ```conf
    [Unit]
    Description=Mailbox synchronization service

    [Service]
    Type=oneshot
    ExecStart=/home/rgr/bin/getmails
    ```

    and activate them

    ```bash
    systemctl --user enable mbsync.timer
    systemctl --user start mbsync.timer
    ```


## ~/bin/getmails

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
if [ $# -eq 0 ]
then
    mbsync -a
else
    mbsync "$@"
fi
pidof mu > /dev/null || mu index
```


# Misc utils


## ~/bin/acpi-powerstate

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/policy-funcs
getState
echo "export POWERSTATE=${STATE}"  > "$HOME"/.acpi-powerstate
export POWERSTATE=$STATE
```


## ~/bin/dropbox-start-once

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
if pidof dropbox > /dev/null ; then
    echo "Dropbox is already running"
else
    if command -v dropbox > /dev/null; then
        echo "Starting Dropbox.."
        if [ "$1" = "async" ]; then
            dropbox start &> /dev/null &
        else
            dropbox start &> /dev/null
        fi
    fi
fi
```


## ~/bin/edit

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
emacs-same-frame "$@"
```


## ~/bin/eman

Use emacs for manpages if it's running might be an idea set an alias such as 'alias man=eman'

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
mp=${1:-"man"}
pgrep -x emacs > /dev/null && ( (emacsclient -c -e "(manual-entry \"-a ${mp}\"))" &> /dev/null) & ) || /usr/bin/man "$@"
```


## ~/bin/expert-advice

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
f=$(command -v fortune >/dev/null && fortune || echo "I don't need to study a subject to have my own truths. Because own truths ARE a thing in 2020.")
if [ "$1" = "t" ]
then
    echo $f | xclip -i -selection clipboard
fi
echo $f
```


## ~/bin/extract-debug-info

strip debug info and store elsewhere

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
scriptdir=`dirname ${0}`
scriptdir=`(cd ${scriptdir}; pwd)`
scriptname=`basename ${0}`

set -e

function errorexit()
{
    errorcode=${1}
    shift
    echo $@
    exit ${errorcode}
}

function usage()
{
    echo "USAGE ${scriptname} <tostrip>"
}

tostripdir=`dirname "$1"`
tostripfile=`basename "$1"`


if [ -z ${tostripfile} ] ; then
    usage
    errorexit 0 "tostrip must be specified"
fi

cd "${tostripdir}"

debugdir=.debug
debugfile="${tostripfile}.debug"

if [ ! -d "${debugdir}" ] ; then
    echo "creating dir ${tostripdir}/${debugdir}"
    mkdir -p "${debugdir}"
fi
echo "stripping ${tostripfile}, putting debug info into ${debugfile}"
objcopy --only-keep-debug "${tostripfile}" "${debugdir}/${debugfile}"
strip --strip-debug --strip-unneeded "${tostripfile}"
objcopy --add-gnu-debuglink="${debugdir}/${debugfile}" "${tostripfile}"
chmod -x "${debugdir}/${debugfile}"

```


## ~/bin/make-compile\_commands

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
make --always-make --dry-run \
    | grep -wE 'gcc|g++' \
    | grep -w '\-c' \
    | jq -nR '[inputs|{directory:".", command:., file: match(" [^ ]+$").string[1:]}]' \
         > compile_commands.json
```


## ~/bin/onehtop

process viewer

```bash
#!/bin/bash
#Maintained in linux-init-files.org
WID=`xdotool search --class "htop"`
if [ -z "$WID" ]; then
    exec terminator --profile=htop -e htop
else
    xdotool windowactivate $WID
fi
```


## ~/bin/oneterminal

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
WID=`xdotool search "One Terminal"|head -1`
if [ -z "$WID" ]; then
    terminator --title="One Terminal" --profile=$(hostname) -e "tmux new-session -A -s oneterminal"
else
    notify-send "restoring OneTerminal instance..."
    xdotool windowactivate $WID
fi
```


## ~/bin/pop-window

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
xdotool windowactivate `xdotool search --name "$1"`
```


## ~/bin/random-man-page

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
man $(find /usr/share/man/man1 -type f | sort -R | head -n1)
```


## ~/bin/remove-broken-symlinks

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
find -L . -name . -o -type d -prune -o -type l -exec rm {} +
```


## ~/bin/remove-conflicted-copies

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
if [ "$1" == "--f" ]; then
    find ~/Dropbox/ -path "*(*'s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -exec rm -f {} \;
    find ~/Dropbox/ -path "*(*s in Konflikt stehende Kopie [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -exec rm -f {} \;

else
    echo "add --f to force deletion of conflicted copies"
    find ~/Dropbox/ -path "*(*'s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -print
    find ~/Dropbox/ -path "*(*s in Konflikt stehende Kopie [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -print
fi
```


## ~/bin/resgithub

reset github as if it's newly born. ALL history will be lost.

```bash
#!/bin/bash
#Maintained in linux-init-files.org
tfile=$(mktemp /tmp/config.XXXXXXXXX)
commitmsg=${1:-"git repository initialised"}
if [ -f .git/config ]; then
    mv .git/config "$tfile"
    rm -rf .git
    git init .
    mv "$tfile" .git/config
    git add .
    git commit -a -m "$commitmsg"
    git push -f
else
    echo "Warning: No git config file found. Aborting.";exit;
fi
```


## ~/bin/sharemouse

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
exec ssh -X ${1-192.168.2.100} x2x -east -to :0
```


## ~/bin/sys-logger

Only log to syslog if MY\_LOGGER -T "STARTUP-INITFILE" \_ON is set

```bash
#!/usr/bin/bash
# Maintained in linux-init-files.org
[ -z "${MY_LOGGER} -T "STARTUP-INITFILE" _ON" ] || /usr/bin/logger -t "startup-initfile"  "$@"
```


## ~/bin/confirm-suspend

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
delay=10;
message="Almost out of juice."
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--delay) delay="${2}";shift;;
        -m|--message) message="${2} ";shift;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

zenity --question --text="${message}Proceed to suspend in ${delay}s?"
if [ $? = 0 ]; then
    sleep "$delay" && systemctl suspend
else
    exit
fi
```


## i3blocks utilities


### ~/bin/my-i3b-battery-status

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
b=`acpi | grep -m 1 -i "remaining\|charging" | sed 's/.*Battery....//I'`
if [ -z "$b" ]; then
    echo "charged";echo ""; echo "#004400";
else
    echo $b;echo "";echo "#FF0000";
fi
```


### ~/bin/my-i3b-db-status

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
if pidof dropbox > /dev/null ; then
    stat=$(dropbox status | sed -n 1p)
    echo "DB:${stat}"; echo "";
    if (( $(wc -w <<< $stat) == 1 )); then
        echo "#004000";
    else
        echo "#800000";
    fi
else
    if command -v dropbox > /dev/null; then
        echo "Starting Dropbox.."
        dropbox start &> /dev/null &
    fi
fi
```


### ~/bin/my-iface-active-query

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
nmcli device show ${IFACE_ACTIVE:-$(my-iface-active)} | grep -i -m 1 "${1:-".*"}.*:" | awk '{print $2}'
```


### ~/bin/my-iface-active

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
IFACE_ACTIVE="$(nmcli device show | grep -m 1 "GENERAL.DEVICE" | awk '{print $2}')"
export IFACE_ACTIVE
echo $IFACE_ACTIVE
```


### ~/bin/my-iface-active-ssid

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
my-iface-active-query "GENERAL.CONNECTION"
```


### ~/bin/my-iface-active-ipaddr

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
my-iface-active-query "IP4.ADDRESS"
```


### ~/bin/my-iface-active-quality

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
my-iface-active-query "GENERAL.STATE"
```


## XMG Neo 15 Specifics


### ~/bin/xmg-neo-rgb-kbd-lights

See [XMGNeo 15 keyboard backlight controller](https://github.com/pobrn/ite8291r3-ctl) for the controller code.

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org

sf="$HOME/.xmg-neo-kbd"

if ! command -v ite8291r3-ctl &> /dev/null;  then
    echo "xmg rgb keyboard light controller not found. install ite8291r3-ctl?"
    exit 1;
fi

save() (
    echo "$lightstatus:$brightness:$color:$rgb" > "$sf"
)

restore(){
    lightstatus="on";brightness=20;rgb="";color="silver";
    if [ -f "$sf" ]; then
        _ifs="$IFS";IFS=':' read -r lightstatus brightness color rgb < "$sf";IFS="$_ifs";
    fi
}

update(){
    if [ "$lightstatus" = "off" ]; then
        ite8291r3-ctl off
    else
        ite8291r3-ctl monocolor $([ -n "$color" ] && echo "--name $color" || echo "--rgb $rgb") --brightness "$brightness" &> /dev/null
    fi
    save
}

restore

case "${1:-on}" in
    on)
        lightstatus="on"
        update
        ;;
    off)
        lightstatus="off"
        update
        ;;
    sleep)
        # use sleep to turn off light for less noise when not interacting with the keyboard
        ite8291r3-ctl brightness 0
        ;;
    wake)
        update
        ;;
    get-brightness)
        ite8291r3-ctl query --brightness
        ;;
    set-brightness)
        brightness=${2:-"$brightness"}
        if [ -z "${brightness##*[!0-9]*}" ]; then
            brightness=50
        elif (( $brightness > 50 )); then
            brightness=50
        fi
        update
        ;;
    set-color)
        color=${2:-"$color"};rgb="";
        update
        ;;
    set-rgb)
        rgb=${2:-"$rgb"};color="";
        update
        ;;
    toggle)
        lightstatus=$( [ $lightstatus = "off" ] && echo "on" || echo "off")
        update
        ;;
    inc)
        ;;
    dec)
        ;;
    *)
        echo "Usage:${0} on|off|sleep|wake|set-brightness|get-brightness|set-color|set-rgb|inc v|dec v"
        exit 1
        ;;
esac

exit 0
```


### test

```bash
xmg-neo-rgb-kbd-lights on
```

```bash
xmg-neo-rgb-kbd-lights off
```

```bash
xmg-neo-rgb-kbd-lights set-brightness 50
```

```bash
xmg-neo-rgb-kbd-lights set-color red
```


## Google Translate Helpers

```bash
sudo apt install translate-shell
```


### ~/bin/google-trans

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
src=$1;shift;
dst=$1;shift;
txt=$@;
trans -e google -s ${src} -t ${dst} -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$txt"
```


### ~/bin/google-trans-de-en

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
trans -e google -s de -t en -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$@"
```


### ~/bin/google-trans-en-de

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
trans -e google -s en -t de -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$@"
```


## Security/Locking/GPG


### ~/bin/cache-gpg

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
SERVICE="gpg-agent"
if pgrep -x "$SERVICE" >/dev/null
then
    echo "agent already running"
else
    p=$(zenity --password --title "Password for SSH")
    if [ ! -z "$p" ]
    then
        [ ! -z "$GPG_KEY1" ] && echo "$p" | /usr/lib/gnupg2/gpg-preset-passphrase --preset "$GPG_KEY1" &> /dev/null
        [ ! -z "$GPG_KEY2" ] && echo "$p" | /usr/lib/gnupg2/gpg-preset-passphrase --preset "$GPG_KEY2" &> /dev/null
    fi
fi

```

\#+end\_src


### ~/bin/pre-lock

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
[ -f "${HOME}"/.pre-lock ]  && . "${HOME}"/.pre-lock
```

1.  Sample .pre-lock

    ```bash
    #!/usr/bin/bash
    xmg-neo-rgb-kbd-lights sleep
    ```


### ~/bin/post-lock

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
x-backlight-persist restore
[ -f "${HOME}"/.post-lock  ]  && . "${HOME}"/.post-lock
```

1.  Sample .post-lock

    ```bash
    #!/usr/bin/bash
    xmg-neo-rgb-kbd-lights wake
    ```


### ~/bin/pre-blank

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
[ -f ~/.pre-blank ]  && . ~/.pre-blank
```


### ~/bin/post-blank

```bash
#!/usr/bin/bash
#Maintained in linux-init-files.org
[ -f ~/.post-blank ]  && . ~/.post-blank
x-backlight-persist restore
```


# tailends


## ~/.bash\_profile

```bash
# export USER_STARTX_NO_LOGOUT_ON_QUIT=""
[ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] && [ -f ~/.START_X ] && {
    echo "Auto starting via startx with USER_STARTX_NO_LOGOUT_ON_QUIT:${USER_STARTX_NO_LOGOUT_ON_QUIT}"
    [ -z "$USER_STARTX_NO_LOGOUT_ON_QUIT" ] && exec startx || startx
}
```


## Late addition to ~/.profile

```bash
[ -f  ~/.profile.local ] && . ~/.profile.local
```
