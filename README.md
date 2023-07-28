# Introduction


## Status

Work in progress!! Keep most config and scripts in a single org file for documentation. Use org tangling for exporting them.


## GIT


### ~/.config/git/config

global git settings NB - NOT Exported as lots of things want to update it

```gitconfig
[user]
        name = rileyrg
        email = rileyrg@gmx.de
[push]
        default = current
[github]
        user = rileyrg
[pull]
        rebase = false
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


# X Related     :ARCHIVE:


# User system services


### gpg-agent

If using startx on debian this is taken care of by the system XSession loading everyhing in /etc/X11/Xsession.d. see [/usr/share/doc/gnupg/examples](file:///usr/share/doc/gnupg/examples)


# Bash Startup Files


## ~/.profile

```bash
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

export PATH="${HOME}/bin":"${HOME}/bin/sway":"${HOME}/.local/bin":"${HOME}/.emacs.d/bin":"${HOME}/.emacs.d/bin/bin":"./node_modules/.bin":"${PATH}"

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



```


## ~/.bash\_profile

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
logger -t "startup-initfile"  BASH_PROFILE

[ -f ~/.profile ] && . ~/.profile || true
[ -f ~/.bashrc ] && . ~/.bashrc || true

```


## ~/.bashrc

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
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


### bash git prompt

```bash
if [ -f "${HOME}/bin/thirdparty/bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source "${HOME}/bin/thirdparty/bash-git-prompt/gitprompt.sh"
fi
```


# ZSH Related


## ~/.config/zsh/.zshrc

```bash
# Maintained in linux-config.org
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

ZSH_THEME=robbyrussell

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
DISABLE_UNTRACKED_FILES_DIRTY="true"

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
    chucknorris
    vi-mode
    tmux
    safe-paste
    colored-man-pages
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

chuck
```


## ~/.config/zsh/.zlogin

```bash
# Maintained in linux-config.org
logger -t "startup-initfile"  ZLOGIN
# [ -s "${HOME}/.rvm/scripts/rvm" ] && source "${HOME}/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
```


## zprofile

1.  ~/.config/zsh/.zprofile

    ```bash
    # Maintained in linux-config.org
    logger -t "startup-initfile"  ZPROFILE
    if [ -f ~/.profile ]; then
        emulate sh -c '. ~/.profile'
    fi
    ```

2.  etc/zsh/zprofile

    ```bash
    # Maintained in linux-config.org
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
    # Maintained in linux-config.org
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

    Link this into ${HOME}
    
    ```bash
    # Maintained in linux-config.org
    logger -t "startup-initfile"  ZSHENV
    if [ -z "$XDG_CONFIG_HOME" ] && [ -d "${HOME}/.config" ]
    then
        export XDG_CONFIG_HOME="${HOME}/.config"
    fi
    
    if [ -d "$XDG_CONFIG_HOME/zsh" ]
    then
        export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    fi
    xhost +SI:localuser:root &> /dev/null
    ```


## Oh-My-Zsh Related

Directory is [here](.oh-my-zsh/).

1.  Aliases ~/.config/zsh/oh-my-zsh/custom/aliases.zsh

    ```conf
    # Maintained in linux-config.org
    alias grep="grep -n --color"
    alias hg='history|grep'
    ```

2.  Functions ~/.config/zsh/oh-my-zsh/custom/functions.zsh

    ```bash
    mkc () {
        mkdir -p "$@" && cd "$@" #create full path and cd to it
    
    }
    ```


## BUGS


### DONE slow git prompt

<https://stackoverflow.com/questions/12765344/oh-my-zsh-slow-but-only-for-certain-git-repo> <https://stackoverflow.com/a/38865693/37370>


# Guix

A package management tool for and distribution of the GNU system

I've removed this for now. Hellishly complex and I have to be honest, I can't make head nor tail of the docs and really cant be reading reams of "freedom" propaganda that requires in a degree in GUIX to understand how to suid a GUIX installed utiliy.

```bash
if [ -d "/gnu" ]; then
    echo "GUIX initialised."
    GUIX_PROFILE="/home/rgr/.guix-profile"
    . "$GUIX_PROFILE/etc/profile"
fi

```


## remove GUIX

```bash
# Maintained in linux-config.org
sudo systemctl stop guix-daemon.service
sudo systemctl stop gnu-store.mount
sudo rm -rf /gnu
sudo rm -rf /var/guix
sudo rm -rf ~/.config/guix
sudo rm -rf /etc/guix#+end_src
rm -rf ~/.guix-profile
```


# Tmux     :tmux:


## ~/.profile

```bash
export FZF_TMUX_OPTS=1
export FZF_TMUX_OPTS="-d 40%"
```


## ~/.tmux.conf


### start

```conf
# Maintained in linux-config.org
# Change the prefix key to C-a
```


### styles

```conf
set-option -g status on
set-option -g status-interval 1
set-option -g status-justify centre
set-option -g status-keys vi
set-option -g status-position bottom
set-option -g status-style fg=colour136,bg=colour235
set-option -g status-left-length 20
set-option -g status-left-style default
set-option -g status-left "#[fg=green]#H #[fg=black]• #[fg=green,bright]#(uname -r)#[default]"
set-option -g status-right-length 140
set-option -g status-right-style default
set-option -g status-right "#[fg=green,bg=default,bright]#(tmux-mem-cpu-load) "
set-option -ag status-right "#[fg=red,dim,bg=default]#(uptime | cut -f 4-5 -d ' ' | cut -f 1 -d ',') "
set-option -ag status-right " #[fg=white,bg=default]%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d"
set-window-option -g window-status-style fg=colour244
set-window-option -g window-status-style bg=default
set-window-option -g window-status-current-style fg=colour166
set-window-option -g window-status-current-style bg=default

set-option -g default-shell /bin/zsh

```


### keys

```conf
set -g prefix C-a
unbind C-b
bind C-a send-prefix

set -g pane-border-format "#{pane_index} #{pane_title} tty:#{pane_tty}"
set -g pane-border-status bottom

# reload tmux config
bind r source-file ~/.tmux.conf \; display-message "Config reloaded..."

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

bind K kill-session
bind x kill-pane
bind X kill-pane -a
bind c command-prompt -p "window name:" "new-window; rename-window '%%'"
new -d -s0
# neww -d -nemacs 'exec emacsclient -nw ~/.emacs.d/linux-init/inits.org'
# setw -t0:1 aggressive-resize on
# neww -d  -nhtop 'exec htop'

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

set -g mouse on
set -g @yank_selection 'clipboard' # 'primary' or 'secondary' or 'clipboard'
set -g @yank_selection_mouse 'clipboard' # or 'primary' or 'secondary'
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'sainnhe/tmux-fzf'

run -b '~/.tmux/plugins/tpm/tpm'

```


## ~/bin/tmux-current-session

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
echo "$(tmux list-panes -t "$TMUX_PANE" -F '#S' | head -n1)"
```


## ~/bin/tmux-pane-tty

Written to find the tty for a pane in order to redirect gef context source to a voltron pane

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
session="${1:-""}"
[ -z ${session} ] && exit 1
pane_index="${2:-0}"
window="${3:-0}"
tmux list-panes -t "${session}:${window}" -F 'pane_index:#{pane_index} #{pane_tty}' | awk '/pane_index:'"${pane_index}"'/ {print $2 }'
```


# Sway Wayland Compositing Tile Manager     :i3:swaywm:sway:

Sway is a tiling Wayland compositor and a drop-in replacement for the i3 window manager for X11. It works with your existing i3 configuration and supports most of i3's features, plus a few extras.


## xkb keyboard

Set keyboard layout. Override in .profile.local

```bash
export XKB_DEFAULT_LAYOUT=de
export XKB_DEFAULT_OPTIONS=ctrl:nocaps
```


## Gnome     :ARCHIVE:


## swaysock for tmux

```bash
export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock
```


## ~/.Xresources


### resource file

X11 apps still need resource definitions when launched under XWayland.

```conf
! Use a truetype font and size.
*.font: -*-JetBrainsMono Nerd Font-*-*-*-*-6-*-*-*-*-*-*
Xft.autohint: 0
Xft.antialias: 1
Xft.hinting: true
Xft.hintstyle: hintslight
Xft.dpi: 96
Xft.rgba: rgb
Xft.lcdfilter: lcddefault

! Fonts {{{
#ifdef SRVR_thinkpadt460
Xft.dpi:       104
#endif
#ifdef SRVR_intelnuc
Xft.dpi:       108
#endif
#ifdef SRVR_thinkpadx270
Xft.dpi:       96
#endif
#ifdef SRVR_thinkpadt14s
Xft.dpi:       96
#endif
#ifdef SRVR_xmgneo
Xft.dpi:       188
#endif
! }}}
```


## Building from source


### wayland

```bash
mkdir -p ${HOME}/development/projects/wayland/clones
export WLD=${HOME}/development/projects/wayland
export LD_LIBRARY_PATH=$WLD/lib
export PKG_CONFIG_PATH=$WLD/lib/pkgconfig/:$WLD/share/pkgconfig/
export PATH=$WLD/bin:$PATH

cd ${HOME}/development/projects/wayland/clones

git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
meson build/ --prefix=$WLD
ninja -C build/ install
cd ..

git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
meson build/ --prefix=$WLD
ninja -C build/ install
cd ..

git clone https://gitlab.freedesktop.org/wayland/weston.git
cd weston
meson build/ --prefix=$WLD -Dbackend-wayland=true -Dcolor-management-colord=false -Dremoting=false
ninja -C build/ install
cd ..

```


### sway

```emacs-lisp
# Clone repositories

git clone git@github.com:swaywm/sway.git
cd sway
git clone git@github.com:swaywm/wlroots.git subprojects/wlroots

# Build sway and wlroots
meson build/
ninja -C build/

# Start sway
build/sway/sway
```


## Sway config


### general

```conf
# Maintained in linux-config.org

# xwayland disable

set $mod Mod4
set $term 'oneterminal'
set $menu 'sway-launcher-fzf'
set $editor 'sway-editor'
set $wallpaper '~/Pictures/Wallpapers/current'

include /etc/sway/config-vars.d/*
include config-vars.d/*

# start a terminal
# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod
# kill focused window
bindsym $mod+q kill
bindsym $mod+0 kill

# Font  for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango: "JetBrainsMono Nerd Font 11"
#DejaVu Sans Mono, Terminus Bold Semi-Condensed 11

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
Bindsym $mod+Shift+r restart

bindsym $mod+Shift+e exec $editor
bindsym $mod+d exec $menu

```


### autostart     :autostart:

```conf
# exec sway-lock
exec sway-kanshi
exec sway-idle
exec '[ -f "${HOME}/.sway-autostart" ]  && . "${HOME}/.sway-autostart" && (sleep 1 && sway-notify "~/.sway-autostart processed")'
exec sleep 2 && gpg-cache
exec blueman-applet
exec nm-applet --indicator
exec dropbox-start-once

```


### library include

```conf
include /etc/sway/config.d/*
```


### host specific     :scale:scaling:

```conf
include "${HOME}/.config/sway/host-config-$(hostname)"
```

1.  Thinkpad T14s

    1.  scaling
    
        ```conf
        #Maintained in linux-config.org
        output eDP-1 mode 1920x1080@60hz scale 1.0
        ```

2.  XMG Neo

    1.  scaling
    
        ```conf
        #Maintained in linux-config.org
        output eDP-1 mode 2560x1440@165hz scale 1.15
        ```


### mbsync

I do this here because the user systemd service wont start with an encrypted HOMEDIR. Normally I'd kick this off in the **.profile** or something.

```conf
exec systemctl start --user mbsync.service
```


### xrdb integration

```conf
exec xrdb -merge ~/.Xresources
```


### mako

done by linux systemd

```conf
# exec mako
```


### launcher

```conf
for_window [title="sway-launcher"] floating enable
```


### display

1.  wallpaper

    ```conf
    set $wallpaper "~/Pictures/Wallpapers/current"
    output * bg  $wallpaper fill
    ```

2.  transparency

    ```conf
    set $trans 0.8
    set $alphamark "α"
    for_window [con_mark=$alphamark] opacity set $trans
    bindsym $mod+Control+a mark --toggle "$alphamark" ; [con_id=__focused__] opacity set 1 ; [con_mark=$alphamark con_id=__focused__] opacity set $trans
    ```

3.  lid     :lid:clamshell:

    ```conf
    set $laptop-id `sway-laptop-id`
    bindswitch lid:on exec "sway-screen disable $laptop-id"
    bindswitch lid:off exec "sway-screen enable $laptop-id"
    ```

4.  brightness     :brightness:

    ```conf
    bindsym --locked XF86MonBrightnessUp exec --no-startup-id light -A 10 && sway-brightness-notify
    bindsym --locked XF86MonBrightnessDown exec --no-startup-id light -U 10 && sway-brightness-notify
    ```

5.  gaps

    ```conf
    gaps inner  1
    gaps outer  0
    ```

6.  all apps

    Borrowed from: <https://github.com/swaywm/sway/issues/4121>
    
    ```conf
    bindsym $mod+a exec swaymsg \[con_id=$(swaymsg -t get_tree | jq -r '.nodes | .[] | .nodes | . [] | select(.nodes != null) | .nodes | .[] | select(.name != null) | "\(.id?) \(.name?)"' | rofi -dmenu -i | awk '{print $1}')] focus
    ```


### scratchpad terminal

I want a key to create and then toggle a terminal.

```conf

bindsym $mod+Shift+minus move scratchpad
bindsym $mod+minus scratchpad show
bindsym $mod+Return exec sway-scratch-terminal

for_window [title=ScratchTerminal] mark "$alphamark", move to scratchpad; [title=ScratchTerminal] scratchpad show
```

1.  ~/bin/sway/sway-scratch-terminal

    ```bash
    #!/usr/bin/env bash
    #Maintained in linux-config.org
    swaymsg "[title=ScratchTerminal] scratchpad show " || ( sway-notify "created new scratchpad terminal" && alacritty --title "ScratchTerminal" --command bash -c "tmux new-session -A -s ScratchTerminal")
    ```


### navigation                                  :navigation

```conf
# change focus
# bindsym $mod+h focus left
# bindsym $mod+j focus down
# bindsym $mod+k focus up
# bindsym $mod+l focus right

bindsym $mod+o focus left

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

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
bindsym $mod+Shift+t inhibit_fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floatving
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+p focus parent

bindsym $mod+Shift+s sticky toggle

bindsym $mod+m move workspace to output left
bindsym $mod+Control+m exec sway-display-swap
bindsym $mod+Tab workspace back_and_forth

# focus the child container
#bindsym $mod+d focus child

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.

set $ws1 1:edit
set $ws2 2:research
set $ws3 3:IDE
set $ws4 4:browse
set $ws5 5:dired
set $ws6 6:music
set $ws7 7:video
set $ws8 8:irc
set $ws9 9:steam
set $ws10 "10"

exec_always sway-screen-naming
# Bindsym F12 exec sway-notify "left:$$leftOutput, right:$$rightOutput"


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
#  bindsym $mod+0 workspace number $ws10

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

bindsym $mod+Control+Shift+Right move workspace to output right
bindsym $mod+Control+Shift+Left move workspace to output left
bindsym $mod+Control+Shift+Down move workspace to output down
bindsym $mod+Control+Shift+Up move workspace to output up


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

```


### clipboard

1.  clipman and wofi

    A basic [clipboard manager](https://github.com/yory8/clipman) for Wayland, with support for persisting copy buffers after an application exits.
    
    ```conf
    set $clipboard "~/.local/share/clipman.json"
    exec wl-paste -t text --watch clipman store --max-items 1024
    bindsym $mod+y exec sway-clipboard-history-select
    bindsym $mod+Control+y exec sway-clipboard-history-clear
    ```
    
    1.  sway-clipboard-history-select
    
        ```bash
        #!/usr/bin/env bash
        # Maintained in linux-config.org
        if ! (clipman pick --tool="wofi" --max-items=30); then
            sway-notify "Clipboard History Is Empty"
            exit 1
        else
            exit 0
        fi
        ```
    
    2.  sway-clipboard-history-clear
    
        ```bash
        #!/usr/bin/env bash
        # Maintained in linux-config.org
        clipman clear -a
        sway-notify "Clipboard history cleared."
        ```
    
    3.  Wofi Config
    
    4.  ~/.config/wofi/config
    
        [Configuration](http://manpages.ubuntu.com/manpages/impish/man5/wofi.5.html) file
        
        ```conf
        # Maintained in linux-config.org
        dynamic_lines=true
        gtk_dark=true
        terminal=alacritty
        ```
    
    5.  ~/.config/wofi/style.css
    
        ```css
        /* Maintained in linux-config.org */
        window {
            margin: 0px;
            border: 1px solid #c0c0c0;
            background-color: #282a36;
        }
        
        #input {
            margin: 2 px;
            border: none;
            color: #222222;
            background-color: #eeeeee;
        }
        
        #inner-box {
            margin: 2px;
            border: none;
            background-color: #282a36;
        }
        
        #outer-box {
            margin: 2px;
            border: none;
            background-color: #282a36;
        }
        
        #scroll {
            margin: 0px;
            border: none;
        }
        
        #text {
            margin: 2px;
            border: none;
            color: #f8f8f2;
        }
        
        #entry:selected {
            background-color: #44475a;
        }
        #entry {
            border-bottom-style: solid;
            border-width: 1px;
            border-color: #d4af37;
        }
        ```


### audio     :audio:

1.  volume     :volume:

    ```conf
    
    bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle && sway-notify "Toggle Mute"
    bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5% && sway-volume-notify
    bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5% && sway-volume-notify
    
    # bindsym XF86AudioRaiseVolume exec pulse-volume "+5%" && sway-volume-notify
    # bindsym XF86AudioLowerVolume exec pulse-volume "-5%" && sway-volume-notify
    # bindsym XF86AudioMute exec pulse-volume "toggle" && sway-volume-notify
    bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle && sway-volume-notify
    
    ```

2.  pavucontrol

    ```conf
    for_window [app_id="pavucontrol"] floating enable
    bindsym $mod+Control+Shift+a exec pulse-restart
    ```


### wifi     :wifi:

```conf
bindsym --locked XF86Wlan exec sleep 1 && sway-notify "WLAN is $(nmcli radio wifi)."
```


### exit, quit, restart, reboot, lock, hibernate, blank, suspend     :hibernate:lock:sleep:blank:blank:restart:exit:reboot:

```conf

set $mode_system System (b) blank (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown
mode "$mode_system" {
bindsym b exec sway-lock-utils blank, mode "default"
bindsym l exec sway-lock-utils lock, mode "default"
bindsym e exec sway-lock-utils logout, mode "default"
bindsym s exec sway-lock-utils suspend, mode "default"
bindsym h exec sway-lock-utils hibernate, mode "default"
bindsym r exec sway-lock-utils reboot, mode "default"
bindsym Shift+s exec sway-lock-utils shutdown, mode "default"
# back to normal: Enter or Escape
bindsym Return mode "default"
bindsym Escape mode "default"
}
bindsym $mod+Control+q mode "$mode_system"
```


### apps default workspace

```conf
# assign [title="dbg:"] $ws3
#assign [app_id="Alacritty"] $ws1
assign [class="Ardour"] $ws6
assign [class="Code"] $ws3
assign [class="Signal"] $ws8
assign [class="jetbrains-studio"] $ws3
assign [app_id="emacs"] $ws1
assign [class="Hexchat"] $ws8
assign [class="discord"] $ws8
assign [class="Steam"] $ws9
```


### apps default appearance

```conf
for_window [class="feh"] floating enable
for_window [class="feh"] floating enable
for_window [class="Conky"] floating enable
for_window [app_id="zenity"] floating enable
for_window [title="wifi"] floating enable
for_window [title="bluetoothctl"] floating enable
```


### apps keybindings

```conf

bindsym $mod+g exec "goldendict \\"`xclip -o -selection clipboard`\\""
bindsym $mod+Control+b exec sway-lock-utils blank

bindsym $mod+l exec sway-lock-utils lock
bindsym Print exec sway-screenshot -i
bindsym $mod+Shift+f exec sway-do-tool "Google-chrome" "sway-www"
bindsym $mod+Control+Shift+f exec  "sway-www"
bindsym $mod+Shift+a exec sway-do-tool "android-studio" "studio.sh"
bindsym $mod+Shift+b exec oneterminal "Process-Monitor-bpytop" bpytop
bindsym $mod+Control+c exec conky
bindsym $mod+Control+s exec sway-do-tool "Signal" "signal-desktop"
bindsym $mod+Control+Shift+s exec sway-do-tool "Steam" "steam"
bindsym $mod+Control+i exec emacsclient -c -eval '(progn (rgr/erc-start))'
bindsym $mod+Control+d exec emacsclient -c -eval '(dired "~")'
bindsym $mod+Control+Shift+d exec sway-screen-menu
bindsym $mod+Control+f exec command -v thunar && thunar || nautilus
bindsym $mod+Control+e exec lldb-ui "/home/rgr/development/projects/emacs/emacs/src" "emacs"; workspace $ws3
bindsym $mod+Control+u exec lldb-ui "/home/rgr/development/education/Udemy/UdemyCpp/Computerspiel1/" "udemy"; workspace $ws3
bindsym $mod+Control+g exec oneterminal "lldb"
bindsym $mod+Control+o exec xmg-neo-rgb-kbd-lights toggle && x-backlight-persist restore
bindsym $mod+Control+p exec sway-htop
bindsym $mod+Control+Shift+p exec htop-regexp
bindsym $mod+Control+t exec sway-notify "Opening NEW terminal instance" && alacritty -e zsh
```


### gaming     :gaming:

1.  steam     :steam:

    ```conf
    for_window [class="steam_app.*"] fullscreen enable
    for_window [class="steam_app*"] inhibit_idle focus
    ```


### status bar

1.  waybar     :waybar:

    <https://github.com/Alexays/Waybar/wiki/Configuration>
    
    ```conf
    bar {
    swaybar_command waybar
    }
    bindsym $mod+Alt+b exec killall -SIGUSR1 waybar
    
    ```
    
    1.  ~/.config/waybar/config
    
        note : "output": "HDMI-A-1", removed
        
        ```json
        {
          "layer": "top",
          "position": "bottom",
          "height": 30,
          "width": 1280,
        
          "modules-left": [
            "sway/workspaces",
            "cpu",
            "temperature",
            "memory",
            "custom/dropbox"
          ],
        
          "modules-center": [
            "custom/weather",
            "custom/clock",
            "idle_inhibitor",
            "custom/monitors"
          ],
        
          "modules-right": [
            "pulseaudio",
            "backlight",
            "battery",
            "custom/power-draw",
            "wlr/taskbar",
            "tray"
          ],
        
          "network": {
            "format-wifi": "<span color='#589df6'></span> <span color='gray'>{signalStrength}%</span>" ,
            "format-ethernet": "{ifname}: {ipaddr}/{cidr} ",
            "format-linked": "{ifname} (No IP) ",
            "format-disconnected": " ",
            "format-alt": "<span color='gray'>{essid}</span> <span color='green'>⬇</span>{bandwidthDownBits} <span color='green'>⬆</span>{bandwidthUpBits}",
            "interval": 60,
            "tooltip-format": "{ifname}  {ipaddr}"
          },
        
        
          "sway/workspaces": {
            "disable-scroll": true,
            "all-outputs": true,
            "format": "{name}",
            "format-icons": {
              "urgent": "<span color='#e85c5c'></span>",
              "focused": "<span color='#8af0f0'></span>",
              "default": "<span color='#b8b8b8'></span>"
            }
          },
        
          "sway/mode": {
            "format": "{}"
          },
        
          "backlight": {
            //		"device": "acpi_video1",
            "format": "{icon} {percent}%",
            "format-icons": ["🔅", "🔆"]
          },
        
          "battery": {
            "states": {
              // "good": 95,
              "warning": 20,
              "critical": 10
            },
            "format": "<span color='gold'>{icon}</span> {capacity}%",
        
            "format-charging": "<span color='gold'> </span> {capacity}% ({time})",
            "format-plugged":  "<span color='gold'>{icon}  </span> {capacity}%",
            //		"format-good": "", // An empty format will hide the module
            "format-discharging": "<span color='yellow'>{icon}</span> {capacity}% ({time})",
            "format-icons": ["", "", "", "", ""],
            "on-click" : "sway-htop"
          },
        
          "custom/clock": {
            "interval": 60,
            "exec": "date +'%a, %d %b: %H:%M'",
            "format": "{} ",
            "max-length": 25
          },
        
          "cpu": {
            "interval": 5,
            "format": "<span color='#eb8a60'> {usage}% ({load})</span>",
            "states": {
              "warning": 70,
              "critical": 90
            },
            "on-click" : "hardinfo"
          },
        
          "idle_inhibitor": {
            "format": "<span color='GOLD'>{icon}</span>",
            "format-icons": {
              "activated": "📀ﰌ",
              "deactivated": "😴"
            },
            "on-click-right": "sway-lock"
          },
          "pulseaudio": {
            "format": "{icon} {volume}% {format_source}",
            "format-muted": "🔇 {format_source}",
            "format-bluetooth": "{icon} {volume}% {format_source}",
            "format-bluetooth-muted": "🔇 {format_source}",
        
            "format-source": " {volume}%",
            "format-source-muted": "",
        
            "format-icons": {
              "headphones": "",
              "handsfree": "",
              "headset": "",
              "phone": "",
              "portable": "",
              "car": "",
              "default": ["🔈", "🔉", "🔊"]
            },
            "on-click": "pulse-volume toggle",
            "on-click-right": "pavucontrol"
          },
        
          "tray": {
            "icon-size": 21,
            "spacing": 5
          },
        
          "custom/weather": {
            "format": "{} ",
            "tooltip": true,
            "interval": 3600,
            "exec": "waybar-weather-json",
            "return-type": "json"
          },
        
          "custom/uptime": {
            "format": "<span color='white'>⌛{}</span>",
            "interval": 60,
            "exec": "uptime -p"
          },
        
          "custom/dropbox": {
            "format": "<span color='gold'>{}</span>",
            "return-type" : "json",
            "interval": 5,
            "exec": "waybar-dropbox-json",
            "tooltip": "true",
            "on-click": "dropbox start && sway-notify 'Restarting Dropbox.'",
            "on-click-right": "sway-www https://www.dropbox.com/h"
          },
          "custom/monitors": {
            "format": "<span color='gold'>{}</span>",
            "return-type" : "json",
            "interval": 10,
            "exec": "waybar-monitors",
            "tooltip": "true",
            "on-click": "sway-screen-menu"
          },
          "custom/bluetooth": {
            "format": "<span color='blue'>{}</span>",
            "interval": 30,
            "exec": "waybar-bluetooth",
            "tooltip": "false",
            "on-click": "sway-bluetooth"
          },
          "custom/power-draw": {
            "format": "<span color='gold'>⚡{}🔋</span>",
            "interval": 5,
            "exec": "waybar-power-draw",
            "tooltip": "false"
          },
        
          "wlr/taskbar": {
            "format": "{icon}",
            "icon-size": 14,
            "icon-theme": "Numix-Circle",
            "tooltip-format": "{title}",
            "on-click": "activate",
            "on-click-middle": "close"
          },
        
          "custom/mynetwork": {
            "format":  "{}",
            "format-wifi":  "📶{ssid}",
            "format-ipaddr": "{ipaddr}",
            "format-ssid": "xx{ssid}xx",
            "format-alt": "{alt}:{}",
            "exec": "waybar-ip-info-json",
            "return-type": "json",
            "interval": 60,
            "on-click-right": "sway-wifi",
            "tooltip-format": "{ssid}",
            "tooltip": "true"
          }
        
        }
        ```
    
    2.  ~/.config/waybar/style.css
    
        ```css
        * {
            border: none;
            background: rgba(28, 28, 28, 0.6);
            border-radius: 0;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 10pt;
            min-height: 0;
        }
        
        #waybar {
            background: rgba(28, 28, 28, 0.6);
            color: #e4e4e4;
        }
        
        #window {
            color: #e4e4e4;
            font-weight: bold;
        }
        
        #workspaces {
            font-size: 8px;
            /*	padding: 0 2px;*/
            margin-left: 8px;
            margin-right: 8px;
            padding-left: 0px;
            padding-right: 0px;
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
            border-top-right-radius: 10px;
            border-bottom-right-radius: 10px;
            background: rgba(28, 28, 28, 0.6);
        }
        
        #workspaces button {
            padding: 0 5px;
            /*	background: rgba(28, 28, 28, 0.9);*/
            color: #b8b8b8;
            /*	margin: 0 1px;*/
        }
        #workspaces button:hover {
            box-shadow: inherit;
            text-shadow: inherit;
        
        }
        
        #workspaces button.focused {
            padding: 0 5px;
            border-radius: 10px;
            /*	background: #00afd7;*/
            color: #8af0f0;
            margin: 0 0px;
        }
        
        #workspaces button.urgent {
            background: #af005f;
            color: #1b1d1e;
        }
        
        #mode {
            background: #af005f;
        }
        
        #custom-bluetooth,#custom-power-draw,#custom-dropbox,#clock, #temperature, #cpu, #memory, #network, #backlight, #pulseaudio, #battery, #tray, #idle_inhibitor {
            padding: 0 3px;
        }
        
        #idle_inhibitor{
            font-size:16px
        }
        
        #clock {
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
        }
        
        @keyframes blink {
            to {
                background-color: darkred;
            }
        }
        
        #battery.warning:not(.charging) {
            background-color: #ff8700;
            color: #1b1d1e;
        }
        #battery.critical:not(.charging) {
            color: white;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }
        #battery,#battery_icon,#battery.charging {
            color:gold
        }
        
        
        #cpu {
        }
        
        #memory {
        }
        
        #network {
        }
        
        #network.disconnected {
            background: #f53c3c;
        }
        
        #pulseaudio {
        }
        
        #pulseaudio.muted {
        }
        
        #custom-weather {
            font-size:12px;
        }
        
        #tray {
            margin-left: 1px;
        }
        ```
    
    3.  scripts
    
        1.  ~/bin/sway/waybar-bluetooth
        
            Thank you <https://github.com/deanproxy/dotfiles/blob/master/linux/i3/scripts/bluetooth>
            
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            
            get_from_file() {
                dev=$1
                name=
                if [ ! -f /tmp/bt-devices.txt ]; then
                    touch /tmp/bt-devices.txt
                    echo ""
                    return
                fi
                for i in `cat /tmp/bt-devices.txt`; do
                    d=`echo $i | awk -F:: '{print $1}'`
                    if [ $d = $dev ]; then
                        name=`echo $i | awk -F:: '{print $2}'`
                    fi
                done
                echo "${name}"
            }
            
            store_file() {
                dev=$1
                name="${2}"
                echo "$dev::${name}" >> /tmp/bt-devices.txt
            }
            
            connections=`hcitool con | sed -n 2p`
            if [ ! -z "$connections" ]; then
                # We have a connection, we want to get the name from a file if we've had
                # it from there before because getting the name of the device connected
                # is very slow and costly.
                dev=`echo $connections | awk '{print $3}'`
                name=`get_from_file $dev`
                if [ -z "$name" ]; then
                    name=`hcitool name $dev | awk '{print $1}'`
                    if [ ! -z "${name}" ]; then
                        store_file $dev "${name}"
                    fi
                fi
                echo "💡$name"
            else
                echo "🔌"
            fi
            ```
        
        2.  ~/bin/sway/waybar-power-draw
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            awk '{print $1*10^-6 " W"}' /sys/class/power_supply/BAT0/power_now
            ```
        
        3.  ~/bin/sway/waybar-dropbox-json
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            if ( ! dropbox running ); then
                fullstat="$(dropbox status)"
                stat="$(sed -n 1p <<< $fullstat)"
            else
                fullstat=""
                if [ -f "${HOME}/.RESTART_DROPBOX" ];then
                    stat="Restarting Dropbox.."
                    sway-notify "$stat"
                    dropbox start &> /dev/null
                else
                    stat="click to restart DB"
                fi
            fi
            
            jq --unbuffered --compact-output -n \
               --arg text "$stat" \
               --arg tooltip "$fullstat" \
               --arg class "dropbox-status" \
               '{text: $text, tooltip: $tooltip, class: $class}'
            ```
        
        4.  ~/bin/sway/waybar-ip-info-json
        
            ```bash
            ifname="${1:-$(printf '%s' /sys/class/net/*/wireless | cut -d/ -f5)}"
            [ -z "$ifname" ] && exit 1
            pubip="$(curl -s -m 1 ipinfo.io/ip)"
            pubip="$([ -z "$pubip" ] && echo "Offline" || echo "$pubip")"
            lip=$(ip -j address | jq -r '.[] | select (.ifname=='\"$ifname\"').addr_info[] | select(.family=="inet").local')
            lip="$([ -z "$lip" ] && echo -n "Offline" || echo -n "$lip")"
            ssid="$(/sbin/iwconfig $ifname | grep 'ESSID:' | awk '{print $4}' | sed 's/ESSID://g' | sed 's/"//g')"
            jq --unbuffered --compact-output -n \
               --arg text "📶 $ssid" \
               --arg alt "$ifname:🌎$pubip,🔌$lip" \
               --arg tooltip "$ifname:🌎$pubip,🔌$lip" \
               --arg class "" \
               --arg percentage "1" \
               --arg ifname "$ifname" \
               --arg ssid "$ssid" \
               --arg public_ip "$pubip" \
               --arg ippadr "$lip" \
               '{text: $text, alt: $alt, tooltip: $tooltip, class: $class, percentage: $percentage, ifname: $ifname, ssid: $ssid, public_ip: $public_ip, ipaddr: $ippadr}'
            ```
        
        5.  ~/bin/sway/waybar-monitors
        
            ```bash
            #!/usr/bin/env bash
            #Maintained in linux-config.org
            l=$(swaymsg -t get_outputs | jq  -r '[ .[] | select(.dpms and .active) ] | length')
            o=$(swaymsg -t get_outputs | jq  -r '. | map(.name) | join(",")')
            t=""
            for i in `seq $l`; do t="${t}🖵";done
            text="{\"text\":\""$t"\",\"tooltip\":\""$o"\"}"
            echo $text
            ```
        
        6.  ~/bin/sway/waybar-wttr
        
            ```python
            #!/usr/bin/env python
            # Maintained in linux-config.org
            
            import json
            import os
            import requests
            from datetime import datetime
            
            WEATHER_CODES = {
                '113': '☀️',
                '116': '⛅️',
                '119': '☁️',
                '122': '☁️',
                '143': '🌫',
                '176': '🌦',
                '179': '🌧',
                '182': '🌧',
                '185': '🌧',
                '200': '⛈',
                '227': '🌨',
                '230': '❄️',
                '248': '🌫',
                '260': '🌫',
                '263': '🌦',
                '266': '🌦',
                '281': '🌧',
                '284': '🌧',
                '293': '🌦',
                '296': '🌦',
                '299': '🌧',
                '302': '🌧',
                '305': '🌧',
                '308': '🌧',
                '311': '🌧',
                '314': '🌧',
                '317': '🌧',
                '320': '🌨',
                '323': '🌨',
                '326': '🌨',
                '329': '❄️',
                '332': '❄️',
                '335': '❄️',
                '338': '❄️',
                '350': '🌧',
                '353': '🌦',
                '356': '🌧',
                '359': '🌧',
                '362': '🌧',
                '365': '🌧',
                '368': '🌨',
                '371': '❄️',
                '374': '🌧',
                '377': '🌧',
                '386': '⛈',
                '389': '🌩',
                '392': '⛈',
                '395': '❄️'
            }
            
            data = {}
            location = os.getenv('WTTR_LOCATION',"")
            
            weather = requests.get("https://wttr.in/" + location + "?format=j1").json()
            
            def format_time(time):
                return time.replace("00", "").zfill(2)
            
            
            def format_temp(temp):
                return (hour['FeelsLikeC']+"°").ljust(3)
            
            
            def format_chances(hour):
                chances = {
                    "chanceoffog": "Fog",
                    "chanceoffrost": "Frost",
                    "chanceofovercast": "Overcast",
                    "chanceofrain": "Rain",
                    "chanceofsnow": "Snow",
                    "chanceofsunshine": "Sunshine",
                    "chanceofthunder": "Thunder",
                    "chanceofwindy": "Wind"
                }
            
                conditions = []
                for event in chances.keys():
                    if int(hour[event]) > 0:
                        conditions.append(chances[event]+" "+hour[event]+"%")
                return ", ".join(conditions)
            
            
            data['text'] = location+":"+WEATHER_CODES[weather['current_condition'][0]['weatherCode']] + \
                " "+weather['current_condition'][0]['FeelsLikeC']+"°"
            
            data['tooltip'] = f"<b>{location}</b>\n"
            data['tooltip'] += f"<b>{weather['current_condition'][0]['weatherDesc'][0]['value']} {weather['current_condition'][0]['temp_C']}°</b>\n"
            data['tooltip'] += f"Feels like: {weather['current_condition'][0]['FeelsLikeC']}°\n"
            data['tooltip'] += f"Wind: {weather['current_condition'][0]['windspeedKmph']}Km/h\n"
            data['tooltip'] += f"Humidity: {weather['current_condition'][0]['humidity']}%\n"
            for i, day in enumerate(weather['weather']):
                data['tooltip'] += f"\n<b>"
                if i == 0:
                    data['tooltip'] += "Today, "
                if i == 1:
                    data['tooltip'] += "Tomorrow, "
                data['tooltip'] += f"{day['date']}</b>\n"
                data['tooltip'] += f"⬆️ {day['maxtempC']}° ⬇️ {day['mintempC']}° "
                data['tooltip'] += f"🌅 {day['astronomy'][0]['sunrise']} 🌇 {day['astronomy'][0]['sunset']}\n"
                for hour in day['hourly']:
                    if i == 0:
                        if int(format_time(hour['time'])) < datetime.now().hour-2:
                            continue
                    data['tooltip'] += f"{format_time(hour['time'])} {WEATHER_CODES[hour['weatherCode']]} {format_temp(hour['FeelsLikeC'])} {hour['weatherDesc'][0]['value']}, {format_chances(hour)}\n"
            
            
            print(json.dumps(data))
            ```
        
        7.  ~/bin/sway/waybar-weather-json
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            sleep 5
            WTTR_LOCATION="${1:-"Grömitz,DE"}"  waybar-wttr
            ```
        
        8.  ~/bin/sway/waybar-dropbox-status
        
            ```bash
            #!/usr/bin/env bash
            #Maintained in linux-config.org
            if pidof dropbox &> /dev/null ; then
                stat=$(dropbox status | sed -n 1p)
                echo "${stat}"; echo "";
            else
                if command -v dropbox > /dev/null; then
                    echo "⇄Restarting Dropbox.."
                    dropbox start &> /dev/null &
                fi
            fi
            ```


## bin,scripts     :sway:wayland:


### ~/bin/sway-sway-active-monitors-count

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
swaymsg -t get_outputs | jq  -r '[ .[] | select(.dpms and .active) ] | length'
```


### ~/bin/sway/sway-autostart

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
[ -f "${HOME}/.sway-autostart" ]  && . "${HOME}/.sway-autostart"
```


### ~/bin/sway/sway-brightness-notify

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
sway-notify "🔆:$(printf "%.0f" `light -G`)"
```


### ~/bin/sway/sway-bluetooth

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
exec oneterminal "bluetoothctl" "bluetoothctl"
```


### ~/bin/sway/sway-do-tool

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org

# NB ths is currently lazy. It uses brute force, and i need to do some get_tree jq stuff instead to
# get the app_id/class instance instead. But.. it works.

id="$1"
script="$2"
[ -z "$id" ] && echo "usage: sway-do-tool id" && exit 1
if swaymsg "[title=${id}] focus" &> /dev/null; then
    rgr-logger -t "sway-do-tool" "title ${id} found"
else
    if  swaymsg "[class=^${id}] focus" &> /dev/null; then
        rgr-logger -t "sway-do-tool" "class ${id} found"
    else
        if  swaymsg "[app_id=^${id}] focus" &> /dev/null; then
            rgr-logger -t "sway-do-tool" "app_id ${id} found"
        else
            if [ ! -z "$script" ]; then
                rgr-logger -t "sway-do-tool" "evaling script $scipt"
                eval "$script" &
            else
                rgr-logger -t "sway-do-tool" "exiting"
                exit 1
            fi
        fi
    fi
fi
exit 0
```


### ~/bin/sway/sway-dpms

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
DPMS="${1:-on}"
DISP="${2:-*}"
currentDPMS="$(swaymsg -t get_outputs | jq -r '.[0]'.dpms)"
[ "$dpms" != "$currentDPMS" ] && swaymsg "output $DISP DPMS $DPMS"
```


### ~/bin/sway/sway-editor

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
exec emacs-same-frame "$@"
```


### ~/bin/sway/sway-htop

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
exec oneterminal "Processes" htop
```


### ~/bin/sway/sway-kanshi

Monitor control with hotplug <https://github.com/emersion/kanshi> Load a host specific kanshi file if it exists

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
# pidof kanshi && echo "kanshi process $(pidof kanshi) already running. Exiting." && exit 0
killall -9 kanshi &>/dev/null
config="${HOME}/.config/kanshi/config-$(hostname)"
if [ -f  "$config" ]; then
    echo  "kanshi -c $config"
    kanshi -c "$config"
else
    echo "kanshi default config"
    kanshi
fi
```

1.  config

    ```conf
    {
    output eDP-1 enable position 0,0
    }
    ```

2.  config-um690

    ```conf
    {
    output HDMI-A-1  mode 2560x1440 position 0,0
    output HDMI-A-2  mode 1920x1080 position 2560,116
    }
    ```

3.  config-thinkpadt14s

    ```conf
    {
    output eDP-1 enable mode 1920x1080  position 0,0
    }
    
    {
    output eDP-1 mode 1920x1080 position 2560,0
    output HDMI-A-1  mode 2560x1440 position 0,0
    }
    
    {
    output eDP-1 mode 1920x1080 position 2560,0
    output DP-1  mode 2560x1440 position 0,0
    }
    
    {
    output eDP-1 mode 1920x1080 position 2560,0
    output DP-2  mode 2560x1440 position 0,0
    }
    
    {
    output eDP-1 mode 1920x1080 position 1920,0
    output DP-4 mode 1920x1080 position 0,0
    }
    
    ```

4.  config-xmgneo

    ```conf
    {
    output eDP-1 enable mode 2560x1440  position 0,0
    }
    
    {
    output eDP-1 mode 2560x1440 position 2560,0
    output HDMI-A-1  mode 2560x1440 position 0,0
    }
    
    {
    output eDP-1 mode 2560x1440 position 2560,0
    output DP-1  mode 2560x1440 position 0,0
    }
    
    ```

5.  config-thinkpadt460

    ```conf
    {
    output eDP-1 enable mode 1366×768   position 0,0
    }
    
    {
    output eDP-1 mode 1366×768  position 1920,0
    output DP-4 mode 1920x1080 position 0,0
    }
    ```

6.  config-thinkpadx270

    ```conf
    {
    output eDP-1 enable mode 1920x1080  position 0,0
    }
    
    {
    output DP-4 mode 1920x1080 position 0,0
    output eDP-1 disable
    }
    
    ```
    
    ******\*******


### ~/bin/sway/sway-lock-utils

Just a gathering place of locky/suspendy type things&#x2026;

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
lock() {
    pidof swaylock || swaylock -f -i ~/Pictures/LockScreen/current -s fill -c 000000 &
}

lock_gpg_clear() {
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
        swaymsg exit
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
    blank)
        sway-dpms off
        [ -f "${HOME}/.screen-blank.local" ] && . "${HOME}/.screen-blank.local"
        ;;
    unblank)
        sway-dpms on
        [ -f "${HOME}/.screen-unblank.local" ] && . "${HOME}/.screen-unblank.local"
        ;;
    *)
        lock
        ;;
esac

exit 0
```


### swayidle, ~/bin/sway/sway-idle     :sleep:lock:idle:

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
pidof swayidle  && killall -9 swayidle
exec swayidle -w \
     timeout 1 '' \
     resume 'sway-lock-utils unblank' \
     timeout 10 'pidof swaylock && sway-lock-utils blank' \
     resume 'sway-lock-utils unblank' \
     timeout ${XIDLEHOOK_BLANK:-3600} 'sway-lock-utils blank' \
     resume 'sway-lock-utils unblank' \
     timeout ${XIDLEHOOK_LOCK:-14400} 'sway-lock-utils lock' \
     resume 'sway-lock-utils unblank' \
     timeout ${XIDLEHOOK_SUSPEND:-43200} 'sway-lock-utils suspend' \
     resume 'sway-lock-utils unblank' \
     lock 'sway-lock-utils lock' \
     unlock 'sway-lock-utils unblank' \
     before-sleep 'sway-lock-utils lock'
```


### ~/bin/sway/sway-laptop-id

Here we look for an env `LAPTOP_ID`. In my setup that would be set in `${HOME}/.profile.local`. If thats not set we assume `eDP-1` but in both cases we check if it exists in the sway tree, and, if not, set it it to the first one found.

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
id="${LAPTOP_ID:-"eDP-1"}"
displays="$(swaymsg -t get_outputs | jq -r '.[0]')"
if [ -z  "$(jq '.|select(.name=="$id") | .name' <<< $displays)" ];then
    id="$(jq -r '[.][0].name' <<< $displays)"
fi
echo $id
```


### ~/bin/sway/sway-lock

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
sway-lock-utils lock
```


### ~/bin/sway/sway-notify

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
notify-send -t 3000 "${@}" || true
```


<a id="org8277240"></a>

### ~/bin/sway/sway-screen

`enable` or `disable`. Won't allow you to turn off the sole enabled display.

:ID: 82455cae-1c48-48b2-a8b3-cb5d44eeaee9

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
m="${2:-$(swaymsg -t get_outputs | jq -r '.[0].name')}"
c="${1:-enable}"
[ "$c" = "disable" ] && [ "$(sway-active-monitors-count)" = "1" ] && sway-notify "Not turning off single display $m" && exit 1
swaymsg "output ${m} ${c}"
(sleep 2 && sway-notify "${m}:${c}") &
```


### ~/bin/sway/sway-screen-naming

See <https://www.reddit.com/r/swaywm/comments/10ys0oy/comment/j80lu88/?context=3>

```bash
#!/usr/bin/env bash

outputs=(
    $(swaymsg -t get_outputs | jq -r 'sort_by(.rect.x) | .[].name')
)

export leftOutput=${outputs[0]}
export rightOutput=${outputs[1]}

swaymsg "
  set \$leftOutput \"$leftOutput\"; set \$rightOutput \"$rightOutput\";
  workspace \$ws1; move workspace to output \"$leftOutput\";
  workspace \$ws6; move workspace to output \"$rightOutput\";
  workspace \$ws1  output \"$leftOutput\";
  workspace \$ws2  output \"$leftOutput\";
  workspace \$ws3  output \"$leftOutput\";
  workspace \$ws6  output \"$rightOutput\";
  workspace \$ws7  output \"$rightOutput\";
  workspace \$ws8  output \"$rightOutput\";
  workspace \$ws9  output \"$rightOutput\";
"
```


### ~/bin/sway/sway-screen-menu

Gui to select a display and enable/disable it. Calls down to [~/bin/sway/sway-screen](#org8277240).

:ID: 82455cae-1c48-48b2-a8b3-cb5d44eeaee9

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
m=$(swaymsg -t get_outputs | jq -r '.[] |  "\(.name)\n\(.active)"'  | zenity  --title "Select Display" --list  --text "" --column "Monitor" --column "Enabled")
if [ ! -z "$m" ]; then
    c="$(zenity  --list  --title "Enable ${m}?" --text "" --radiolist  --column "Pick" --column "Enabled" TRUE enable FALSE disable)"
    if [ ! -z "$c" ]; then
        sway-screen $c $m
    fi
fi
exit 0
```


### ~/bin/sway/sway-swaysock     :swaysock:

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock
```


### ~/bin/sway/sway-display-swap

<https://i3wm.org/docs/user-contributed/swapping-workspaces.html>

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org

DISPLAY_CONFIG=($(swaymsg -t get_outputs | jq -r '.[]|"\(.name):\(.current_workspace)"'))

for ROW in "${DISPLAY_CONFIG[@]}"
do
    IFS=':'
    read -ra CONFIG <<< "${ROW}"
    if [ "${CONFIG[0]}" != "null" ] && [ "${CONFIG[1]}" != "null" ]; then
        echo "moving ${CONFIG[1]} right..."
        swaymsg -- workspace --no-auto-back-and-forth "${CONFIG[1]}"
        swaymsg -- move workspace to output right
    fi
done
```


### ~/bin/sway/sway-launcher-wofi

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
exec dmenu_path | wofi --show drun,dmenu -i | xargs swaymsg exec --
```


### ~/bin/sway/sway-launcher-fzf

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
exec alacritty --title "sway-launcher" -e bash -c "dmenu_path | fzf | xargs swaymsg exec"
```


### ~/bin/sway/sway-screenshot

Thanks: <https://www.reddit.com/r/linuxmasterrace/comments/k1bjkp/i_wrote_a_trivial_wrapper_for_taking_screenshots/>

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
# thanks to: https://www.reddit.com/r/linuxmasterrace/comments/k1bjkp/i_wrote_a_trivial_wrapper_for_taking_screenshots/

DIR=${HOME}/tmp/Screenshots

mkdir -p "${DIR}"

FILENAME="screenshot-$(date +%F-%T).png"
region="$(slurp)"
if [ ! -z "$region" ]; then
    sway-notify "Taking pic in 5s.."
    sleep 5
    grim -g "$region" "${DIR}"/"${FILENAME}" || exit 1
    #Create a link, so don't have to search for the newest
    ln -sf "${DIR}"/"${FILENAME}" "${DIR}"/screenshot-latest.png
    sway-notify "Done! see ${DIR}/screenshot-latest.png"
fi
```


### ~/bin/sway/sway-volume-notify

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
volume="$(pulse-volume)"
exec sway-notify "🔊$([ $volume = "off" ] && echo "Muted" || echo "$volume%")" &> /dev/null
```


### ~/bin/sway/sway-weather

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
sway-www "https://www.accuweather.com/en/de/gr%C3%B6mitz/23743/hourly-weather-forecast/176248"
```


### sway-nvidia     :nvidia:dgpu:

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
sway --my-next-gpu-wont-be-nvidia "$@"
```


### ~/bin/sway/sway-www

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
# google-chrome   "$@" &> /dev/null &
google-chrome  -enable-features=UseOzonePlatform -ozone-platform=wayland "$@" &> /dev/null &
sleep 0.5 && sway-do-tool "Google-chrome"
```


### ~/bin/sway/sway-wifi

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
oneterminal "wifi" "nmtui"  &>/dev/null
```


## wayland utils


### notification daemon

1.  mako

    Use mako as the notification daemon
    
    1.  install
    
        ```bash
        sudo apt install mako-notifier
        ```
    
    2.  ~/.config/mako/config
    
        ```conf
        default-timeout=10000
        ```
    
    3.  notification daemon
    
        ```bash
        sudo apt install notification-daemon libnotifier-bin
        ```
        
        Enable it as a dbus service <https://wiki.archlinux.org/title/Desktop_notifications> $XDG\_DATA\_HOME/dbus-1/services/org.freedesktop.Notifications.service
        
        ```conf
        [D-BUS Service]
        Name=org.freedesktop.Notifications
        Exec=/usr/lib/notification-daemon/notification-daemon
        ```


# Vim


## ~/.vimrc

```conf
" Maintained in linux-config.org
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


## ~/.ignore

```conf
# Maintained in linux-config.org
*~
.git
cache
.cache
```


## ~/.ripgreprc

```conf

# Maintained in linux-config.org
# Don't let ripgrep vomit really long lines to my terminal, and show a preview.
--max-columns=150

# Set the colors.
--color=never
--colors=line:none
--colors=line:style:bold

# Because who cares about case!?
--smart-case

#ignore .gitignore
# --no-ignore-vcs


```


## ~/development/projects/.gitignore

```conf
# Maintained in linux-config.org
!*
```


# Conky


## ~/.config/conky/conky.conf

```conf
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
font = 'DejaVu Sans Mono:size=8',
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


# Programming Related     :programming:


## dart/flutter     :dart:flutter:

<https://dart.dev/get-dart#install-a-debian-package> <https://docs.flutter.dev/get-started/install/linux>


### path

```bash
export PATH="${HOME}/bin/thirdparty/flutter/bin:$PATH"
```


## llvm     :llvm:


### path

```bash
export PATH="${HOME}"/bin/llvm:"${HOME}"/bin/llvm/build/bin:"$PATH"
```


### lldb     :lldb:

1.  ~/.lldbinit

    ```conf
    # Maintained in linux-config.org
    
    #settings write -f .lldb-settings-local-start
    #settings read  -f .lldb-settings-local
    
    settings set target.load-cwd-lldbinit true
    settings set interpreter.prompt-on-quit false
    settings set target.x86-disassembly-flavor intel
    
    command alias bfl breakpoint set -f %1 -l %2
    command alias lv command script import "/home/rgr/.local/lib/python3.9/site-packages/voltron/entry.py"
    command alias sl source list -a $rip
    command alias so thread step-out
    #auto breaks  - annotate code with labels eg debug_inspect__var_of_interest
    command alias b_inspect breakpoint set -p "debug_inspect_"
    command alias b_call breakpoint set -p "debug_call_"
    
    # regexp break points arent pending/deferred
    #b_inspect
    #b_call
    
    command regex rlook 's/(.+)/image lookup -rn %1/'
    
    #breg X will break at *X* labels
    command regex breg 's/(.+)/breakpoint set -p "%1"/'
    #bdeb X will break at debug*X labels
    command regex bdeb 's/(.+)/breakpoint set -p "debug_(.+)%1"/'
    #bcall X will break at debug_call__X labels
    command regex bcall 's/(.+)/breakpoint set -p "debug_call__%1"/'
    #binsp X will break at debug_inspect__X labels
    command regex binsp 's/(.+)/breakpoint set -p "debug_inspect__%1"/'
    
    command regex srcb 's/([0-9]+)/settings set stop-line-count-before %1/'
    srcb 2
    command regex srca 's/([0-9]+)/settings set stop-line-count-after %1/'
    srca 3
    
    settings set stop-disassembly-display no-debuginfo
    
    #step into stl
    settings set target.process.thread.step-avoid-regexp ""
    
    
    #alias vtty = shell tmux-pane-tty voltron 4
    
    #define voltron-source-tty
    #shell tmux-pane-tty
    #end
    
    ```

2.  scripts

    1.  ~/bin/llvm/disassembly\_mode.py
    
        [disassembly\_mode.py](directories/bin/lldb/disassembly_mode.py)
    
    2.  ~/bin/llvm/lldb-ui-session
    
        Create a session but let someone else do the attach
        
        ```bash
        #!/usr/bin/env bash
        # Maintained in linux-config.org
        
        # create a lldb debug session unless it already exists.
        # the -d to new session says "dont attach to current terminal"
        # there is a bug where the splt panes split that of a tmux session in the terminal
        # we issue the command from. No idea why or how.
        # directory="$(realpath -s "${1:-`pwd`}")"
        directory="${1:-`pwd`}"
        session="${2:-"voltron-$(basename "$directory")"}"
        if ! TMUX= tmux has-session -t "$session" &> /dev/null; then
        
            tmux new-session -d -c "$directory" -s "$session" 'voltron-source 32'
            firstPane=$(tmux display-message -p "#{pane_id}")
            firstWindow=$(tmux display-message -p "#{window_id}")
        
            srcPane="$firstPane"
        
            tmux splitw -h -p 70 -t "$srcPane" voltron-disassembly-mixed
            disassPane=$(tmux display-message -p "#{pane_id}")
        
        
            tmux splitw -v -p 30 -t "$srcPane" voltron-locals
            localsPane=$(tmux display-message -p "#{pane_id}")
        
            tmux new-window voltron-disassembly &> /dev/null
            sourcePane=$(tmux display-message -p "#{pane_id}")
        
            tmux splitw -v -p 30 -t "$sourcePane" voltron-locals
            localsPane=$(tmux display-message -p "#{pane_id}")
        
            tmux splitw -h -p 70 -t "$sourcePane" voltron-registers
            registersPane=$(tmux display-message -p "#{pane_id}")
        
            tmux splitw -h -p 70 -t "$localsPane" voltron-backtrace
            backTracePane=$(tmux display-message -p "#{pane_id}")
        
            tmux select-window -t "$firstWindow"
            tmux select-pane -t "$firstPane"
        
        fi
        echo "$session"
        ```
    
    3.  ~/bin/llvm/lldb-ui
    
        ```bash
        #!/usr/bin/env bash
        # Maintained in linux-config.org
        directory="${1:-`pwd`}"
        session="$(lldb-ui-session "${directory}" "$2")"
        ONETERM_TITLE="dbg:lldb-$session"  oneterminal "$session"
        ```
    
    4.  emacs
    
        1.  build-emacs
        
            build and install in own bin directory
            
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            cd ~/development/projects/emacs/emacs || return
            ./configure --prefix=/home/rgr/.emacs.d/bin
            make -j"$(nproc)" && make install
            ```
    
    5.  lldb voltron scripts
    
        1.  ~/bin/llvm/voltron-backtrace
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            voltron v c 'thread backtrace'
            ```
        
        2.  ~/bin/llvm/voltron-breakpoints
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            voltron v c 'breakpoint list'
            ```
        
        3.  ~/bin/llvm/voltron-disassembly
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            voltron v c 'disassemble --pc --context '"${1:-4}"' --count '"${2:-4}"''
            ```
        
        4.  ~/bin/llvm/voltron-disassembly-mixed
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            voltron v c 'disassemble --mixed --pc --context '"${1:-1}"' --count '"${2:-32}"''
            ```
        
        5.  ~/bin/llvm/voltron-locals
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            voltron v c 'frame variable' --lexer c
            ```
        
        6.  ~/bin/llvm/voltron-registers
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            voltron v registers
            ```
        
        7.  ~/bin/llvm/voltron-source
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            voltron v c 'source list -a $rip -c '"${1:-32}"''
            ```
        
        8.  ~/bin/llvm/voltron-stack
        
            ```bash
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            voltron v stack
            ```
    
    6.  lldb python scripting     :python:
    
        lldb also has a built-in Python interpreter, which is accessible by the “script” command. All the functionality of the debugger is available as classes in the Python interpreter, so the more complex commands that in gdb you would introduce with the “define” command can be done by writing Python functions using the lldb-Python library, then loading the scripts into your running session and accessing them with the “script” command.
        
        <https://lldb.llvm.org/use/python.html>
        
        1.  TODO follow up on SE post
        
            <https://stackoverflow.com/questions/68207020/trying-to-run-pdb-in-an-imported-lldb-python-script-results-in-error-attributeer>


## gdbgui

<https://www.gdbgui.com/>


### fix for python 3.9

```conf
export PURE_PYTHON=1
```


## haskell

```bash
# haskell
source "${HOME}/.ghcup/env"
```


## python


### pyvenv  <https://github.com/pyenv/pyenv#installation>

1.  add pyenv to path

    ```bash
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    ```


### Debuggers     :debuggers:

1.  pdb     :pdb:

    <https://docs.python.org/3/library/pdb.html> The official python debugger [/home/rgr/development/projects/Python/debugging/pdb](file:///home/rgr/development/projects/Python/debugging/pdb)

2.  ipdb     :ipdb:

    <https://pypi.org/project/ipdb/>
    
    1.  installing
    
        ```bash
        pip install ipdb
        ```
    
    2.  Better Python Debugging
    
        <https://hasil-sharma.github.io/2017-05-13-python-ipdb/>
    
    3.  ~/.ipdb
    
        ```conf
        # Maintained in linux-config.org
        context=5
        ```


## platformio     :platformio:

```bash
# platformio integration - point to pio ide (vscode) stuff.
export PATH="${PATH}:${HOME}/.platformio/penv/bin"
```


## Android     :android:


### Sdk     :sdk:

```bash
# android sdk
export ANDROID_HOME="${HOME}/development/Android/Sdk"
export PATH="${PATH}:${ANDROID_HOME}/emulator"
export PATH="${PATH}:${ANDROID_HOME}/platform-tools"

export ANDROID_STUDIO_HOME="${HOME}/bin/thirdparty/android-studio"
export PATH="${PATH}:${ANDROID_STUDIO_HOME}/bin"

```


## npm     :npm:


### global -g     :global:

```bash
export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
```


## stm32     :embedded:stm32:


### stm32cubeide     :stm32cubeide:

1.  path

    ```bash
    # platformio integration - point to pio ide (vscode) stuff.
    export PATH="${PATH}:${HOME}/bin/thirdparty/stm32cubeide_1.9.0"
    ```

2.  install / uninstall

    ```bash
    #!/usr/bin/env bash
    #Maintained in linux-config.org
    version="${1:-${STM32CUBEIDE_VERSION:-"1.9.0"}}"
    echo "Removing st-stm32cubeide-${version}"
    sudo dpkg -r st-stm32cubeide-"$version"
    sudo dpkg -r st-stlink-server
    sudo dpkg -r st-stlink-udev-rules
    sudo dpkg -r segger-jlink-udev-rules
    ```

3.  STM32CubeMX app

    This is a bit defunct now (may 2022) as they have packaged their code into exes. Also there is a wayland exe.
    
    :ID: b9b221b0-510f-415b-8819-c96b6e00a1d9 :header-args:tangle: no
    
    ```bash
    #!/usr/bin/env bash
    #Maintained in linux-config.org
    java -jar ~/bin/thirdparty/STM32CubeMX/STM32CubeMX
    ```

4.  sway

    ```conf
    for_window [class="STM32CubeIDE"] floating enable
    assign [class="STM32CubeIDE"] $ws3
    assign [title="STM32CubeIDE"] $ws3
    ```

5.  launcher for X11 compatability

    pending deletion
    
    ```bash
    #!/usr/bin/env bash
    # Maintained in linux-config.org
    JAVA_AWT_WM_NONREPARENTING=1 GDK_BACKEND=x11 exec "/opt/st/stm32cubeide_${STM32CUBEIDE_VERSION:-"1.7.0"}/stm32cubeide"
    ```


# PGP/GNUPG/GPG


## ~/.gnupg/gpg.conf

```conf
# Maintained in linux-config.org
use-agent
```


## ~/.gnupg/gpg-agent.conf

```conf
# Maintained in linux-config.org
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


## ~/.profile.local     :crypt:

&#x2013;&#x2014;BEGIN PGP MESSAGE&#x2013;&#x2014;

hQEMA7IjL5SkHG4iAQgAnAMLgodgtOc1tsGz6mRqJbkJsM+R+5MTPdsOdml6xMoL xFZjkYTDUGa3G6PsQHpbJ/tjD+6B4qmZIymq1EReWPtrepGGN6DNG8hLPVNnQ+9N WAFaK1o+gzzfsw9XuptT5Um47k2G3zm019mGKDe0OwYJJ/r/DTHpz9yI9nj5lVdq sdk0Y/WQL/5mcraC7LPz0FhIhuXqKKFNvcQCA6D0fTWJxlzqvXRzuc44LN+mvozq 9Q4WbvXp/etZjeiUYjXmz70KEYxFIch3OR4EGmV41apfojLTmR9R2dp/u3jYexMy NlXugS5egyP+ioiuuTcCsSjN4rxnDwSW868lLkdhIdLAPgFdxEWpJjtaJO0A9aIB 6lJTRLKPzuwTyGiyRdKO8yqYFYwllgfEr/87qcB/ajjRpkhw9tlD8zTrODt4ZUu2 MQQHK2rzvplmgDf2LvDMiM2gv7z4bI3YzOTiGu6m+SxW/j8LA71WRMwhFmUObgOb g44XzdKHAV0o0Q/ZPPnJU4dlKc9nRkNS3MzpORmUGAT1/FSwt+q7uzpuBTZ1crGl P/fo8sDBBu2QBoL2+gQZ11l7uSZMjTCR/8msBO5LbLDmyOUposbv6va1dzPN898F ZsaqN9VNjV2b75kQiPJsZaoekClV7yOFc10/VRKBFD1MlspEovrIpReI9by6azIU =nb0T &#x2013;&#x2014;END PGP MESSAGE&#x2013;&#x2014;


# ACPI


## power status


### acpid events

You must copy these into [*etc/acpi/events*](file:///etc/acpi/events/) if you have an encrypted home directory else symlink.

1.  /etc/acpi/events/user-powerstate

    ```conf
    # Maintained in linux-config.org
    # /etc/acpi/events/user-powerstate
    # Called when the user connects ac power to us
    #
    event=ac_adapter.*
    action=/etc/acpi/actions/user-powerstate.sh
    ```

2.  /etc/acpi/events/xmg-neo-powerstate

    ```conf
    # Maintained in linux-config.org
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
    #!/usr/bin/env bash
    # Maintained in linux-config.org
    # /etc/acpi/actions/user-powerstate
    . /usr/share/acpi-support/power-funcs
    . /usr/share/acpi-support/policy-funcs
    getState
    echo "export POWERSTATE=${STATE}"  > /tmp/user-acpi-powerstate
    export POWERSTATE=$STATE
    ```

2.  /etc/acpi/actions/xmg-neo-powerstate.sh

    ```bash
    #!/usr/bin/env bash
    # Maintained in linux-config.org
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
# Maintained in linux-config.org
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
#!/usr/bin/env bash
# Maintained in linux-config.org
if [ $# -eq 0 ]
then
    mbsync -a
else
    mbsync "$@"
fi
pidof mu &> /dev/null || mu index
```


# bin


## SDR

Software Defined Radio


### ~/bin/AIS

Used in conjunction with [AIS-dispatcher](https://www.aishub.net/ais-dispatcher). Utilies [AIS-catcher](https://github.com/jvde-github/AIS-catcher).

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
TMUX= tmux new  -A -s "AIS" AIScatcher
```


### ~/bin/AIScatcher

Used in conjunction with [AIS-dispatcher](https://www.aishub.net/ais-dispatcher). Utilies [AIS-catcher](https://github.com/jvde-github/AIS-catcher).

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
"${HOME}/bin/AIS-catcher"  -d:0 -u 127.0.0.1 2345
```


### ~/bin/AIScheck

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
if ! pgrep AIS-catcher >/dev/null
then
    echo "`date`: AIS-catcher down. Restarting." >> "${HOME}/.AISStatus"
    "${HOME}/bin/AIScatcher" &> /dev/null &
fi
```

1.  cron entry

    To edit the user cron table:
    
    ```bash
    sudo crontab -u rgr -e
    ```
    
    entry to check every 15 minutes
    
    > \*/15 \* \* \* \* /home/rgr/bin/AIScheck


## one commands

if it exists jump to it else start it


### ~/bin/oneinstance

```bash
#!/bin/bash
#Maintained in linux-config.org
# oneinstance exename pname  winclass
exename=$1;pname="${2:-"$exename"}";winclass={$3:-${pname}};
if ! pidof "$pname"; then
    ${exename}
else
    xdotool windowactivate $(head -n 1 <<< $(xdotool search --name "${winclass}"))
fi
```


### ~/bin/oneterminal

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org

sessionname="${1:-`pwd`}"
title="${ONETERM_TITLE:-${sessionname}}"
script="${2}"

if ! sway-do-tool "$title"; then
    alacritty --title "${title}" --command bash -c "tmux new-session -A -s ${sessionname} ${script}" &
else
    if ! tmux has-session -t  "${sessionname}"; then
        tmux attach -t "${sessionname}"
    fi
fi
exit 0

```


### ~/bin/pop-window

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
sway-do-tool "$@"
```


## network interface utilities

1.  ~/bin/my-iface-active-query

    ```bash
    #!/usr/bin/env bash
    #Maintained in linux-config.org
    nmcli device show ${IFACE_ACTIVE:-$(my-iface-active)} | grep -i -m 1 "${1:-".*"}.*:" | awk '{print $2}'
    ```

2.  ~/bin/my-iface-active

    ```bash
    #!/usr/bin/env bash
    #Maintained in linux-config.org
    IFACE_ACTIVE="$(nmcli device show | grep -m 1 "GENERAL.DEVICE" | awk '{print $2}')"
    export IFACE_ACTIVE
    echo $IFACE_ACTIVE
    ```

3.  ~/bin/my-iface-active-ssid

    ```bash
    #!/usr/bin/env bash
    #Maintained in linux-config.org
    my-iface-active-query "GENERAL.CONNECTION"
    ```

4.  ~/bin/my-iface-active-ipaddr

    ```bash
    #!/usr/bin/env bash
    #Maintained in linux-config.org
    my-iface-active-query "IP4.ADDRESS"
    ```

5.  ~/bin/my-iface-active-quality

    ```bash
    #!/usr/bin/env bash
    #Maintained in linux-config.org
    my-iface-active-query "GENERAL.STATE"
    ```


## ~/bin/confirm-suspend

```bash
  #!/usr/bin/env bash
  #Maintained in linux-config.org
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
#+end_src** ~/bin/dropbox-start-once
#+begin_src bash :tangle "~/bin/dropbox-start-once"
  #!/usr/bin/env bash
  # Maintained in linux-config.org
  if (! dropbox running) ; then
      echo "Dropbox is already running"
  else
      dropbox start &> /dev/null &
  fi
```


## ~/bin/edit

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
${VISUAL:-${EDITOR:-vi}} "${@}"
```


## ~/bin/eman

Use emacs for manpages if it's running might be an idea set an alias such as 'alias man=eman'

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
mp="${1:-man}"
if pidof emacs; then
    emacsclient -c -e "(manual-entry \"-a ${mp}\")" &> /dev/null &
else
    oneterminal random-man "man $mp"
fi
```


## ~/bin/expert-advice

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
f=$(command -v fortune &>/dev/null && fortune || echo "I don't need to study a subject to have my own truths. Because own truths ARE a thing in 2020.")
if [ "$1" = "t" ]
then
    echo $f | xclip -i -selection clipboard
fi
echo $f
```


## ~/bin/extract-debug-info

strip debug info and store elsewhere

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
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
strip --strip-debug  "${tostripfile}"
#objcopy --add-gnu-debuglink="${debugdir}/${debugfile}" "${tostripfile}"
chmod -x "${debugdir}/${debugfile}"

```


## ~/bin/htop-regexp

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
filter="${1:-"$(zenity --entry --text "HTop filter" --title "htop regexp")"}"
[ -z "$filter" ] && exit 1
session="${2:-"htop-filter-${filter//[^[:alnum:]]/}"}"
pids=$(ps aux | awk '/'"${filter}"'/ {print $2}' | xargs | sed -e 's/ /,/g')
if tmux has-session -t "${session}"; then
    tmux kill-session -t "${session}"
    sleep 0.1
fi
tmux new-session -d -s "${session}" "htop -p $pids"
sleep 0.1
ONETERM_TITLE="filtered htop:${filter}" oneterminal "${session}"
```


## ~/bin/make-compile\_commands

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
make --always-make --dry-run \
    | grep -wE 'gcc|g++' \
    | grep -w '\-c' \
    | jq -nR '[inputs|{directory:".", command:., file: match(" [^ ]+$").string[1:]}]' \
         > compile_commands.json
```


## ~/bin/pulse-volume

pulse/pipeline volume control. Pass in a volume string to change the volume (man pactl) or on/off/toggle. It wont allow larger than 100% volume. Always returns the current volume volume/status. See [examples](#org0c409bc).

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org

getVolume(){
    if [ "$(pactl list sinks | grep Mute | awk '{print $2}')" = "yes" ]; then
        echo "off"
    else
        SINK=$( pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1 )
        echo "$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')"
    fi
}

v="$1"

case "$v" in
    "on"|"off"|"toggle")
        pactl set-sink-mute @DEFAULT_SINK@  "$([ "$v" = "off" ] && echo "1" || ( [ "$v" = "on" ] && echo "0" || echo "toggle"))"
        ;;
    *)
        if [ ! -z "$v" ];then
            pactl set-sink-mute @DEFAULT_SINK@ 0
            pactl set-sink-volume @DEFAULT_SINK@ "$v"
            if [ "$(getVolume)" -gt 100 ]; then
                pactl set-sink-volume @DEFAULT_SINK@ "100%"
            fi
        fi
        ;;
esac

echo "$(getVolume)"
```


<a id="org0c409bc"></a>

### Examples:

1.  increase by 10%

    ```bash
    pulse-volume "+10%"
    ```

2.  decrease by 10%

    ```bash
    pulse-volume "-10%"
    ```

3.  set to 50%

    ```bash
    pulse-volume "50%"
    ```

4.  mute

    ```bash
    pulse-volume "off"
    ```

5.  unmute

    ```bash
    pulse-volume "on"
    ```

6.  toggle mute

    ```bash
    pulse-volume "toggle"
    ```


## ~/bin/pulse-restart

restart pulseaudio

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
pulseaudio -k &> /dev/null
pulseaudio -D &> /dev/null
start-pulseaudio-x11
```


## ~/bin/random-man-page

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
page="$(find /usr/share/man/man1 -type f | sort -R | head -n1)"
eman "$page"
```


## ~/bin/remove-broken-symlinks

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
find -L . -name . -o -type d -prune -o -type l -exec rm {} +
```


## ~/bin/remove-conflicted-copies

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
if [ "$1" == "--f" ]; then
    find ~/Dropbox/ -path "*(*'s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -exec rm -f {} \;
    find ~/Dropbox/ -path "*(*s in Konflikt stehende Kopie [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -exec rm -f {} \;

else
    echo "add --f to force deletion of conflicted copies"
    find ~/Dropbox/ -path "*(*'s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -print
    find ~/Dropbox/ -path "*(*s in Konflikt stehende Kopie [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -print
fi
```


## ~/bin/resgithub.sh

[resgithub.sh - reset local and remote git repo](https://github.com/rileyrg/resgithub)

```bash
#!/usr/bin/bash
#Maintained in resgithub.org
tconfig=$(mktemp)
texclude=$(mktemp)
commitmsg=${1:-"git repository initialised"}
if [ -f .git/config ]; then
    cp .git/config "$tconfig"
    cp .git/info/exclude "$texclude"
    rm -rf .git
    git init .
    mv "$tconfig" .git/config
    mv "$texclude" .git/info/exclude
    git add .
    git commit -a -m "$commitmsg"
    git push -f
else
    echo "test Warning: No git config file found. Aborting.";exit;
fi
```


## ~/bin/rgr-logger

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
[ -z "$RGR_LOGGER" ] || logger "$@"
```


## ~/bin/rsnapshot-if-mounted

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
mountpoint=${1:-"/media/rsnapshot"};
rsnapshottype=${2:-"alpha"};
if $(/usr/bin/mountpoint -q $mountpoint); then
    echo "$mountpoint is mounted";
    /usr/bin/rsnapshot -v "$rsnapshottype";
else
    echo "$mountpoint not mounted";
fi;
```


## ~/bin/sharemouse

,#+begin\_src bash :tangle "~/bin/sharemouse" #!/usr/bin/env bash #Maintained in linux-config.org exec ssh -X ${1-192.168.2.100} x2x -east -to :0 \#+end\_src


## ~/bin/wifi-toggle

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
status="$(nmcli radio wifi)"
if [ "$status" = "enabled" ]; then
    nmcli radio wifi off
    echo "Wifi Off"
else
    nmcli radio wifi on
    echo "Wifi On"
fi
```


## ~/bin/upd

update sw

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
export DEBIAN_FRONTEND=noninteractive
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y
```


## XMG Neo 15 Specifics


### ~/bin/xmg-neo-rgb-kbd-lights

See [XMGNeo 15 keyboard backlight controller](https://github.com/pobrn/ite8291r3-ctl) for the controller code.

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org

sf="${HOME}/.xmg-neo-kbd"

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


## Power Monitoring


### ~/bin/acpi-powerstate

```bash
#!/usr/bin/env bash
# Maintained in linux-config.org
. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/policy-funcs
getState
echo "export POWERSTATE=${STATE}"  > "${HOME}"/.acpi-powerstate
export POWERSTATE=$STATE
```


### NVIDIA

1.  ~/bin/nvidia-power-usage

    ```bash
    #!/usr/bin/env bash
    # Maintained in linux-config.org
    for i in $(seq 1 ${1:-5})
    do
        sleep ${2:-1} && echo "$(date +"%Y-%m-%d %H:%M:%S"):$(nvidia-smi -q -d POWER | grep Draw | sed 's/  */ /g')"
    done
    
    ```


## Google Translate Helpers

```bash
sudo apt install translate-shell
```


### ~/bin/google-trans

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
src=$1;shift;
dst=$1;shift;
txt=$@;
trans -e google -s ${src} -t ${dst} -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$txt"
```


### ~/bin/google-trans-de-en

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
trans -e google -s de -t en -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$@"
```


### ~/bin/google-trans-en-de

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
trans -e google -s en -t de -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$@"
```


## Security/Locking/GPG


### ~/bin/gpg-cache

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
if ! pidof gpg-agent; then
    cachefile="${1:-"${HOME}/.gnupg/auth/cache-keys"}"
    if [ -f "$cachefile" ]; then
        p=$(zenity --password --title "Password for SSH")
        if [ ! -z "$p" ]; then
            while IFS= read -r k; do
                [ ! -z "$p" ] && echo "$p" | /usr/lib/gnupg2/gpg-preset-passphrase --preset "$k"
            done < "$cachefile"
        fi
    fi
fi
```

\#+end\_src


### ~/bin/pre-lock

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
[ -f "${HOME}"/.pre-lock ]  && . "${HOME}"/.pre-lock
```

1.  Sample .pre-lock

    ```bash
    #!/usr/bin/env bash
    xmg-neo-rgb-kbd-lights sleep
    ```


### ~/bin/post-lock

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
[ -f "${HOME}"/.post-lock  ]  && . "${HOME}"/.post-lock
```

1.  Sample .post-lock

    ```bash
    #!/usr/bin/env bash
    xmg-neo-rgb-kbd-lights wake
    ```


### ~/bin/pre-blank

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
command -v brightnessctl && brightnessctl -s
[ -f ~/.pre-blank ]  && . ~/.pre-blank
```


### ~/bin/post-blank

```bash
#!/usr/bin/env bash
#Maintained in linux-config.org
[ -f ~/.post-blank ]  && . ~/.post-blank
command -v brightnessctl && brightnessctl -r
```


# tailends


## ~/.bash\_profile

```bash
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
```


## Late addition to ~/.profile

```bash
# fix for java apps in sway
export _JAVA_AWT_WM_NONREPARENTING=1
[ -f "${HOME}/.profile.local" ] && . "${HOME}/.profile.local"
```