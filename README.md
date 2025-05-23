

# Introduction


## Status

Work in progress!!
Keep most  config and scripts in a single org file for documentation. Use org tangling for exporting them.


## GIT


### ~/.config/git/config

global git settings
NB - NOT Exported as lots of things want to update it

    [user]
            name = rileyrg
            email = rileyrg@gmx.de
    [push]
            default = current
    [github]
            user = rileyrg
    [pull]
            rebase = false


### master branch, no commit

    #!/bin/sh
    branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$branch" = "master" ]; then
        echo "You can't commit directly to master branch"
        exit 1
    fi


# Basic shell things


## X/Sway common

    ! Maintained in linux-config.org
    ! Use a truetype font and size.
    *.font: -*-JetBrainsMono Nerd Font-*-*-*-*-14-*-*-*-*-*-*
    Xft.autohint: 0
    Xft.antialias: 1
    Xft.hinting: true
    Xft.hintstyle: hintslight
    Xft.dpi: 96
    Xft.rgba: rgb
    Xft.lcdfilter: lcddefault
    
    ! Fonts {{{
    #ifdef SRVR_t460
    Xft.dpi:       104
    #endif
    #ifdef SRVR_intelnuc
    Xft.dpi:       108
    #endif
    #ifdef SRVR_x270
    Xft.dpi:       96
    #endif
    #ifdef SRVR_t14s
    Xft.dpi:       96
    #endif
    #ifdef SRVR_x1c6
    Xft.dpi:       96
    #endif
    #ifdef SRVR_x13amdg4
    Xft.dpi:       96
    #endif
    #ifdef SRVR_xmgneo
    Xft.dpi:       188
    #endif
    ! }}}


## Bash Startup Files


### ~/.profile

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
    
    # export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig
    
    export ARDUINO_SDK_PATH="${HOME}"/cloud/homefiles/development/arduino/arduinoSDK
    export CMAKE_EXPORT_COMPILE_COMMANDS=1
    
    export RIPGREP_CONFIG_PATH="${HOME}"/.ripgreprc
    
    # OBS recording studio
    # export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORM="xcb"
    
    #alias man=eman
    
    export PATH="${HOME}/bin":"${HOME}/bin/sway":"${HOME}/.local/bin":"${HOME}/.emacs.d/bin":"${HOME}/bin/thirdparty/emacs/bin":"${HOME}/.cargo/bin":"./node_modules/.bin":"${PATH}"
    
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    export USE_GPG_FOR_SSH="yes" # used in xsession
    
    if [ -z "$XDG_CONFIG_HOME" ]
    then
        export XDG_CONFIG_HOME="${HOME}/.config"
    fi
    
    # for sway waybar tray
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    
    export GRIM_DEFAULT_DIR="${HOME}/tmp"
    
    systemctl start --user mbsync.timer
    
    #homebrew
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"


### ~/.bash\_profile

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    logger -t "startup-initfile"  BASH_PROFILE
    [ -f ~/.profile ] && . ~/.profile || true
    [ -f ~/.bashrc ] && . ~/.bashrc || true
    #emacs --bg-daemon  &> /dev/null &


### ~/.bashrc

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
    # Set up fzf key bindings and fuzzy completion
    eval "$(fzf --bash)"

1.  bash git prompt

        if [ -f "${HOME}/bin/thirdparty/bash-git-prompt/gitprompt.sh" ]; then
            GIT_PROMPT_ONLY_IN_REPO=1
            source "${HOME}/bin/thirdparty/bash-git-prompt/gitprompt.sh"
        fi


## ZSH Related


### ~/.config/zsh/.zshrc

    # Maintained in linux-config.org
    logger -t "startup-initfile"  ZSHRC
    [[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
    export TERM="kitty"
    # Path to your oh-my-zsh installation.
    export ZSH="${XDG_CONFIG_HOME}/zsh/oh-my-zsh"
    
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        ZSH_TMUX_AUTOSTART=true
    else
        ZSH_TMUX_AUTOSTART=false
    fi
    
    # ZSH_TMUX_
    AUTOSTART_ONCE=true
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
    export HISTFILE=${XDG_CONFIG_HOME}/zsh/.zsh_history_$HOST
    
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
    # Set up fzf key bindings and fuzzy completion
    source <(fzf --zsh)
    command -v "fdfind" >> /dev/null && export FZF_DEFAULT_COMMAND="fdfind . $HOME"
    
    [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
        source "$EAT_SHELL_INTEGRATION_DIR/zsh"
    
    xhost +local: > /dev/null 2>&1


### ~/.config/zsh/.zlogin

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


### zprofile

    # Maintained in linux-config.org


### ~/.zshenv

    # Maintained in linux-config.org
    if [ -z "$XDG_CONFIG_HOME" ] && [ -d "${HOME}/.config" ]
    then
        export XDG_CONFIG_HOME="${HOME}/.config"
    fi
    
    xhost +SI:localuser:root &> /dev/null
    
    ZDOTDIR=$HOME/.config/zsh
    [ -f "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"


### Oh-My-Zsh Related

Directory is [here](.oh-my-zsh/).

1.  Aliases ~/.config/zsh/oh-my-zsh/custom/aliases.zsh

        # Maintained in linux-config.org
        alias grep="grep -n --color"
        alias hg='history|grep'
        alias vi='vim'

2.  Functions ~/.config/zsh/oh-my-zsh/custom/functions.zsh

        mkc () {
            mkdir -p "$@" && cd "$@" #create full path and cd to it
        
        }


## Tmux     :tmux:


### ~/.profile

    export FZF_TMUX_OPTS=1
    export FZF_TMUX_OPTS="-d 40%"


### .config/tmux/tmux.conf

    # Maintained in linux-config.org
    # Change the prefix key to C-a
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
    set-option -ga update-environment SWAYSOCK
    
    set -g prefix C-a
    
    unbind C-b
    bind C-a send-prefix
    
    set -g pane-border-format "#{pane_index} #{pane_title} tty:#{pane_tty}"
    set -g pane-border-status bottom
    
    # reload tmux config
    bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."
    
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
    bind + new-window
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
    
    run -b '~/.config/tmux/plugins/tpm/tpm'


### ~/bin/tmux-current-session

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    echo "$(tmux list-panes -t "$TMUX_PANE" -F '#S' | head -n1)"


### ~/bin/tmux-pane-tty

Written to find the tty for a pane in order to redirect gef context source to a voltron pane

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    session="${1:-""}"
    [ -z ${session} ] && exit 1
    pane_index="${2:-0}"
    window="${3:-0}"
    tmux list-panes -t "${session}:${window}" -F 'pane_index:#{pane_index} #{pane_tty}' | awk '/pane_index:'"${pane_index}"'/ {print $2 }'


# Power Related

Caveat - for my thinkpads.
Script that checks for a .BATTERY\_POWER\_LOW file and if its there and
we're discharging, it suspends the laptop. If it's there and we're
charging it deletes it. If its not there and we're below a certain
threshold and we're discharging, create. It runs as a looping bash
script kicked off in **.profile** as cron jobs cant escalate systemctl
priviliges. Or something.


## requirements

Linux sys directory ***sys/class/power\_supply/BAT0*** is
there. **notify-send** and **beep** are installed.


## ~/bin/discharge-suspend

If you want to stop the suspend then create file
**~/.BAT\_POWER\_SUSPEND\_SUSPEND**. This defaults to 30% battery level as
the suspend threshold but you can set an ENV variable
**BAT\_POWER\_SUSPEND\_LEVEL** to override it. The polling period is every
ten minutes which can be overridden with the ENV
**.BAT\_POWER\_POLL\_SUSPEND\_CYCLE**.

I launch it from my **.profile**. see below.

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    
    # loop and check power levels every BAT_POWER_SUSPEND_POLL_CYCLE seconds. When a certain
    # threshold, BAT_POWER_SUSPEND_LEVEL, is reached then, unless there is
    # a check file ~/.BAT_POWER_SUSPEND_SUSPEND, in which case we just repeat
    # warnings, suspend in BAT_POWER_SUSPEND_TIME seconds. Calling the sister scriptdir
    # discharge-suspend-toggle toggles suspend process.
    
    if [ ! -f /sys/class/power_supply/BAT0/status ];then
        exit 1
    fi
    
    rm -f ~/.BAT_POWER_SUSPEND_SUSPEND
    BAT_POWER_SUSPEND_POLL_CYCLE=${BAT_POWER_SUSPEND_POLL_CYCLE:-60}
    BAT_POWER_SUSPEND_LEVEL=${BAT_POWER_SUSPEND_LEVEL:-25}
    BAT_POWER_SUSPEND_TIME=${BAT_POWER_SUSPEND_TIME:-600}
    BAT_POWER_SUSPEND_CRITICAL_LEVEL=${BAT_POWER_SUSPEND_CRITICAL_LEVEL:-5}
    
    BAT_POWER_SUSPEND_SUSPENDING=false
    # if suspend is suspended only warn every five minutes or so...
    BAT_POWER_SUSPEND_SUSPEND_WARN_PERIOD=${BAT_POWER_SUSPEND_SUSPEND_WARN_PERIOD:-300}
    
    LASTWARN=0
    
    while true;  do
        sleep ${BAT_POWER_SUSPEND_POLL_CYCLE}
        mapfile -t batStats< <(cat /sys/class/power_supply/BAT0/{status,capacity})
        status=${batStats[0]}
        level=${batStats[1]}
        if [ ${status} = "Discharging" ]; then
            CRITICAL=FALSE
            if ((${level} <= ${BAT_POWER_SUSPEND_LEVEL})); then
                if ((${level} <= ${BAT_POWER_SUSPEND_CRITICAL_LEVEL}));then
                    #if at a critical level then time to call it a day and suspend
                    rm -f ~/.BAT_POWER_SUSPEND_SUSPEND
                    BAT_POWER_SUSPEND_SUSPENDING=true
                    notify-send "**CRITICIAL**" "LOW BATTERY"
                    CRITICAL=true
                    [ ! -f ~/.BAT_POWER_SUSPEND_SILENT ] && beepy
                fi
                # unless we're overriding the auto suspend then check if we should
                if [ ! -f ~/.BAT_POWER_SUSPEND_SUSPEND ]; then
                    #if we're already in the process of suspending see if its time to suspend
                    if [ ${BAT_POWER_SUSPEND_SUSPENDING} = true ]; then
                        if [ ${CRITICAL} = true ] || ((${SECONDS} >= ${BAT_POWER_SUSPEND_TIME}));then
                            notify-send "**SUSPENDING**" "in 10 SECONDS"
                            [ ! -f ~/.BAT_POWER_SUSPEND_SILENT ] && beepy
                            sleep 10
                            systemctl suspend
                            BAT_POWER_SUSPEND_SUSPENDING=false
                        else
                            notify-send "**WARNING**" "Battery low: suspending in about $((${BAT_POWER_SUSPEND_TIME}-${SECONDS}))s"
                        fi
                    else
                        # initiate the suspending period
                        BAT_POWER_SUSPEND_SUSPENDING=true
                        SECONDS=0
                        notify-send "**WARNING**" "Battery low: suspending in ${BAT_POWER_SUSPEND_TIME}s"
                        [ ! -f ~/.BAT_POWER_SUSPEND_SILENT ] && beepy
                    fi
                else
                    # since suspend is being overridden, just warn of low battery
                    BAT_POWER_SUSPEND_SUSPENDING=false
                    if (( ${BAT_POWER_SUSPEND_SUSPEND_WARN_PERIOD} + ${LASTWARN}  < ${SECONDS} )); then
                        notify-send "**WARNING**" "Battery low: ${level}%"
                        LASTWARN=${SECONDS}
                    fi
                fi
            fi
        else
            # we're not discharging so cancel any suspend operations
            if [ ${BAT_POWER_SUSPEND_SUSPENDING} = true ]; then
                notify-send "**Charging detected**" "Suspending cancelled"
                BAT_POWER_SUSPEND_SUSPENDING=false
                SECONDS=0
            fi
        fi
    done


## ~/bin/discharge-suspend-toggle

toggle existence of **~/.BAT\_POWER\_SUSPEND\_SUSPEND**

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    if [ -f ~/.BAT_POWER_SUSPEND_SUSPEND ];then
        rm ~/.BAT_POWER_SUSPEND_SUSPEND;
        sway-notify "Auto suspend re-enabled"
        beepy
    else
        touch ~/.BAT_POWER_SUSPEND_SUSPEND;
        sway-notify "Auto suspend disabled"
    fi


## ENV SET

    # export BAT_POWER_SUSPEND_LEVEL=30
    # export BAT_POWER_SUSPEND_POLL_CYCLE=300


## exec discharge-suspend

this goes into my .profile

    if [ -z "$SSH_CONNECTION" ]; then
        (pgrep -f "discharge-suspend" > /dev/null ||  discharge-suspend &) 2>&1
    fi


# syncing


## sync-to

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    set -x
    rsync -avx --exclude-from "${HOME}/cloud/.rsync-ignore" --delete ~/cloud/ ${1:-richiehh}:cloud/
    set +x


## sync-from

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    set -x
    cwd=$(pwd)
    rsync -avx --exclude-from "${HOME}/cloud/.rsync-ignore" --delete ${1:-richiehh}:cloud/ ${HOME}/cloud/
    cd ${HOME}
    ln -sf ${HOME}/cloud/homefiles/DotFiles/.* .
    cd ${HOME}/.config
    ln -sf ~/cloud/homefiles/dot-config/* .
    cd ${cwd}
    set +x


# Network


## ~/bin/network-online

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    wget -q --spider http://google.com


# Editors


## emacs


### sway-editor

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway-do-tool "Emacs-general" || emacsclient -s "general" -n -c && sleep 1 && sway-do-tool "Emacs-general"


## Vim


### ~/.vimrc

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
    Plug 'doums/darcula'
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
    
    colorscheme darcula


# ripgrep


## ~/.ignore

    # Maintained in linux-config.org
    *~
    .git
    cache
    .cache


## ~/.ripgreprc

    
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


# Sway Wayland Compositing Tile Manager     :i3:swaywm:sway:

Sway is a tiling Wayland compositor and a drop-in replacement for the i3 window manager for X11.
It works with your existing i3 configuration and supports most of i3's features, plus a few extras.


## xkb keyboard

Set keyboard layout.
Override in .profile.local

    export XKB_DEFAULT_LAYOUT=de
    export XKB_DEFAULT_OPTIONS=ctrl:nocaps


## SwayWM config


### general

    # Maintained in linux-config.org
    
    # Logo key. Use Mod1 for Alt.
    set $mod Mod4
    set $super Mod4
    
    # Home row direction keys, like vim
    set $left h
    set $down j
    set $up k
    set $right l
    
    
    set $term 'kitty'
    set $menu 'sway-launcher'
    set $editor 'sway-editor'
    set $wallpaper '~/Pictures/Wallpapers/current '
    
    # Font  for window titles. Will also be used by the bar unless a different font
    # is used in the bar {} block below.
    font pango: "JetBrainsMono Nerd Font 6"
    #DejaVu Sans Mono, Terminus Bold Semi-Condensed 11
    
    mouse_warping output
    
    bar {
    swaybar_command waybar
    }
    
    bindsym $mod+b exec killall -SIGUSR1 waybar
    
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
    
    bindsym $mod+Control+q exec command -v wlogout && wlogout || swaymsg 'mode "$mode_system"'
    
    #
    # Resizing containers:
    #
    mode "resize" {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    # bindsym $left resize shrink width 10px
    # bindsym $down resize grow height 10px
    # bindsym $up resize shrink height 10px
    # bindsym $right resize grow width 10px
    
    # Ditto, with arrow keys
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px
    
    # # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
    }
    
    bindsym $mod+r mode "resize"
    
    ### Key bindings
    #
    # Basics:
    #
    # Kill focused window
    bindsym $mod+Shift+q kill
    bindsym $mod+q kill
    
    # Start your launcher
    bindsym $mod+d exec $menu
    
    # Start your editor
    bindsym $mod+Shift+e exec $editor
    
    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    # Despite the name, also works for non-floating windows.
    # Change normal to inverse to use left mouse button for resizing and right
    # mouse button for dragging.
    floating_modifier $mod normal
    
    # Reload the configuration file
    bindsym $mod+Control+c reload
    
    # Exit sway (logs you out of your Wayland session)
    # bindsym $mod+Control+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
    
    #
    # Moving around:
    #
    # Move your focus around
    # bindsym $mod+$left focus left
    # bindsym $mod+$down focus down
    # bindsym $mod+$up focus up
    # bindsym $mod+$right focus right
    # # Or use $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right
    
    # Move the focused window
    # bindsym $mod+Shift+$right move right
    # bindsym $mod+Shift+$left move left
    # bindsym $mod+Shift+$down move down
    # bindsym $mod+Shift+$up move up
    # Ditto, with arrow keys
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
    # #
    # # Workspaces:
    #
    # Switch to workspace
    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4
    bindsym $mod+5 workspace 5
    bindsym $mod+6 workspace 6
    bindsym $mod+7 workspace 7
    bindsym $mod+8 workspace 8
    bindsym $mod+9 workspace 9
    bindsym $mod+0 workspace 10
    # Move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace 1
    bindsym $mod+Shift+2 move container to workspace 2
    bindsym $mod+Shift+3 move container to workspace 3
    bindsym $mod+Shift+4 move container to workspace 4
    bindsym $mod+Shift+5 move container to workspace 5
    bindsym $mod+Shift+6 move container to workspace 6
    bindsym $mod+Shift+7 move container to workspace 7
    bindsym $mod+Shift+8 move container to workspace 8
    bindsym $mod+Shift+9 move container to workspace 9
    bindsym $mod+Shift+0 move container to workspace 10
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.
    
    # bindsym $mod+control+shift+$right move workspace to output right
    # bindsym $mod+control+shift+$left move workspace to output left
    # bindsym $mod+control+$right move container to output right
    # bindsym $mod+control+$left move container to output left
    bindsym $mod+control+shift+right move workspace to output right; #focus output right;
    bindsym $mod+control+shift+left move workspace to output left; # focus output left;
    bindsym $mod+control+shift+down move workspace to output down; #focus output down;
    bindsym $mod+control+shift+up move workspace to output up; focus #output up;
    
    bindsym $mod+control+right move container to output right; focus output right;
    bindsym $mod+control+left move container to output left; focus output left;
    bindsym $mod+control+down move container to output down; focus output down;
    bindsym $mod+control+up move container to output up; focus output up;
    
    bindsym $mod+Control+m exec sway-display-swap
    bindsym $mod+Tab workspace back_and_forth
    
    #
    # Layout stuff:
    
    bindsym $mod+h splith
    bindsym $mod+v splitv
    
    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split
    
    # Make the current focus fullscreen
    bindsym $mod+f fullscreen
    
    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle
    
    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle
    
    # Move focus to the parent container
    bindsym $mod+a focus parent
    
    #
    # Scratchpad:
    #
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.
    bindsym $mod+Return exec sway-scratch-terminal
    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad
    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show


### host specific     :scale:scaling:

    include "${HOME}/.config/sway/host-config-$(hostname)"

1.  Thinkpad T14s

    1.  scaling
    
            #Maintained in linux-config.org
            output eDP-1 mode 1920x1080@60hz scale 1.0

2.  XMG Neo

    1.  scaling
    
            #Maintained in linux-config.org
            output eDP-1 mode 2560x1440@165hz scale 1.15


### launcher

    for_window [title="sway-launcher"] floating enable


### display

1.  wallpaper

        # done in sway-workspace-init
        # output * bg  $wallpaper fill

2.  transparency

        set $trans 0.7
        set $alphamark "α"
        for_window [con_mark=$alphamark] opacity set $trans
        bindsym $mod+Control+a mark --toggle "$alphamark" ; [con_id=__focused__] opacity set 1 ; [con_mark=$alphamark con_id=__focused__] opacity set $trans

3.  lid     :lid:clamshell:

        set $laptop-id `sway-laptop-id`
        bindswitch lid:on exec "sway-screen disable $laptop-id"
        bindswitch lid:off exec "sway-screen enable $laptop-id"

4.  brightness     :brightness:

        bindsym --locked XF86MonBrightnessUp exec --no-startup-id brightnessctl set +${BRIGHTNESS_DELTA:-15} && sway-brightness-notify
        bindsym --locked XF86MonBrightnessDown exec --no-startup-id brightnessctl set ${BRIGHTNESS_DELTA:-15}- && sway-brightness-notify

5.  gaps

        gaps inner  1
        gaps outer  0


### scratchpad terminal

$term is set to "sway-scratch-terminal

    for_window [title=ScratchTerminal] mark "$alphamark", move to scratchpad; [title=ScratchTerminal] scratchpad show

1.  ~/bin/sway/sway-scratch-terminal

        #!/usr/bin/env bash
        #Maintained in linux-config.org
        swaymsg "[title=ScratchTerminal] scratchpad show " ||  (sway-notify "created new scratchpad terminal" && kitty --title "ScratchTerminal" -e tmux new-session -A -s ScratchTerminal)


### navigation                                  :navigation


### clipboard

1.  clipman and wofi

    A basic [clipboard manager](https://github.com/yory8/clipman) for Wayland, with support for persisting copy buffers after an application exits.
    
        set $clipboard "~/.local/share/clipman.json"
        exec wl-paste -t text --watch clipman store
        exec wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"
        bindsym $mod+y exec sway-clipboard-history-select
        bindsym $mod+Control+y exec sway-clipboard-history-clear
    
    1.  sway-clipboard-history-select
    
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            if ! (clipman pick --tool="wofi" --max-items=30); then
                sway-notify "Clipboard History Is Empty"
                exit 1
            else
                exit 0
            fi
    
    2.  sway-clipboard-history-clear
    
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            clipman clear -a
            sway-notify "Clipboard history cleared."
    
    3.  Wofi Config
    
    4.  ~/.config/wofi/config
    
        [Configuration](http://manpages.ubuntu.com/manpages/impish/man5/wofi.5.html) file
        
            # Maintained in linux-config.org
            dynamic_lines=true
            gtk_dark=true
            terminal=kitty
    
    5.  ~/.config/wofi/style.css
    
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


### audio     :audio:

1.  volume     :volume:

        
        bindsym XF86AudioMute exec  sway-volume-notify "0"
        bindsym $mod+XF86AudioMute exec  pavucontrol
        bindsym XF86AudioRaiseVolume exec sway-volume-notify "+"
        bindsym XF86AudioLowerVolume exec sway-volume-notify "-"
        # bindsym XF86AudioRaiseVolume exec pulse-volume "+5%" && sway-volume-notify
        # bindsym XF86AudioLowerVolume exec pulse-volume "-5%" && sway-volume-notify
        bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle && sway-volume-notify

2.  pavucontrol

        for_window [app_id="pavucontrol"] floating enable
        bindsym $mod+Control+Shift+a exec pulse-restart


### wifi     :wifi:

    bindsym --locked XF86Wlan exec sleep 1 && sway-notify "WLAN is $(nmcli radio wifi)."


### apps default workspace

    # assign [title="dbg:"] 3
    #assign [app_id="Alacritty"] 1
    #assign [class="Ardour"] 6
    assign [class="Code"] 3
    assign [class="Signal"] 8
    assign [class="jetbrains-studio"] 3
    assign [class="Hexchat"] 8
    assign [app_id="telegram"] 8
    assign [class="discord"] 8
    assign [class="Steam"] 9


### apps default appearance

    for_window [title="wifi"] floating enable
    for_window [title="bluetoothctl"] floating enable
    # for_window [title="YouTube"] move container to workspace  7


### apps keybindings

    
    bindsym $mod+g exec "goldendict \\"`xclip -o -selection clipboard`\\""
    
    bindsym $mod+Print exec sway-screenshot -i
    bindsym $mod+Control+Print exec sway-screen-recorder
    
    bindsym $mod+Shift+f exec "sway-chrome"
    bindsym $mod+Shift+m exec sway-do-tool "wwwemail" "sway-email"
    bindsym $mod+Shift+a exec sway-do-tool "android-studio" "studio.sh"
    bindsym $mod+Control+Shift+s exec sway-do-tool "Steam" "steam"
    bindsym $mod+Control+i exec sway-do-tool "Emacs-irc" || emacsclient -s "irc" -c -n  && sleep 0.5 && sway-do-tool "Emacs-irc"
    bindsym $mod+Control+d exec sway-do-tool "Emacs-dired" || emacsclient -s "dired" -n -c  && sleep 0.5  && sway-do-tool "Emacs-dired"
    bindsym $mod+Control+e exec sway-do-tool "Emacs-email" || emacsclient -s "email" -n -c  && sleep 0.5  && sway-do-tool "Emacs-email"
    bindsym $mod+Control+Shift+d exec sway-screen-menu
    bindsym $mod+Control+f exec command -v thunar && thunar || nautilus
    bindsym $mod+Control+p exec sway-htop
    bindsym $mod+Control+Shift+p exec htop-regexp
    bindsym $mod+Control+f10 exec sway-notify "Opening NEW terminal instance" && kitty
    bindsym $mod+Control+t exec sway-notify "Opening NEW tmux terminal instance" && kitty tmux new
    bindsym $mod+Control+w exec sway-workspace-position
    bindsym $mod+Control+shift+u exec sway-workspace-populate


### 


### sway startup processes

    #   exec mako
    #  exec bluetooth-headphone-controls
      exec sway-idle
      exec sway-kanshi
      exec blueman-applet &>/dev/null
      exec waybar-network-applet
      # exec gpg-cache
      exec 'sway-workspace-populate-conditional; [ -f "${HOME}/.sway.login" ]  && . "${HOME}/.sway.login" && (sleep 1 && sway-notify "~/.sway.login processed"); sway-workspace-position; swaymsg workspace 1; '


## waybar config

<https://github.com/Alexays/Waybar/wiki/Configuration>

    
    {
        "layer": "top",
        "mode": "hide",
        "position": "top",
        "height": 22,
        "width": 0,
    
        "modules-left": [
            "sway/workspaces",
            "cpu",
            "temperature",
            "memory"
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
            "power-profiles-daemon",
            "custom/power-draw", 
            "tray"
        ],
        "network": {
            "format-wifi": "<span color='#589df6'></span> <span color='gray'>{signalStrength}%</span>" ,
            "format-ethernet": "{ifname}: {ipaddr}/{cidr} ",
            "format-linked": "{ifname} (No IP) ",
            "format-disconnected": " ",
            "format-alt": "<span color='gray'>{essid}</span> <span color='green'>⬇</span>{bandwidthDownBits} <span color='green'>⬆</span>{bandwidthUpBits}",
            "interval": 60,
            "tooltip-format": "{ifname}  {ipaddr}",
            "on-click": "sway-wifi"
        },
    
    
        "sway/workspaces": {
            "persistent_workspaces": {
                "1": ["DP-4"],
                "2": ["DP-4"],
                "3": [],
                "4": ["DP-3"],
                "5": [],
                "6": [],
                "7": [],
                "8": [],
                "9": [],
                "10": []
            },
            "disable-scroll": true,
            "all-outputs": false,
            "format": "({name}){icon}",
            "format-icons": {
                "1": "⌨ Edit",
                "2": "🔍 Research",
                "3": "👷 IDE",
                "4": "🪲 Debug",
                "5": "📁 Files",
                "6": "🎧 Music",
                "7": "⏵ Video",
                "8": "🗨 IRC",
                "9": "Steam",
                "10":"Scratch",
            },
        },
    
        "sway/mode": {
            "format": "{}"
        },
    
        "backlight": {
            //		"device": "acpi_video1",
            "format": "{icon} {percent}%",
            "format-icons": ["", ""]
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
            "on-click-right": "discharge-suspend-toggle"
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
    
        "custom/monitors": {
            "format": "<span color='gold'>{}</span>",
            "return-type" : "json",
            "interval": 10,
            "exec": "waybar-monitors",
            "tooltip": "true",
            "on-click": "sway-screen-menu"
        },
        "custom/bluetooth": {
            "format": "<span color='white'>  </span>",
            "interval": 30,
            "exec": "waybar-bluetooth",
            "tooltip": "false",
            "on-click": "blueman-manager"
        },
        "custom/power-draw": {
            "format": "<span color='gold'>⚡{}🔋</span>",
            "interval": 5,
            "exec": "waybar-power-draw",
            "tooltip": "false"
        },
        "power-profiles-daemon": {
            "format": " {icon}{profile} ",
            "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
            "tooltip": true,
            "format-icons": {
                "default": "",
                "performance": "",
                "balanced": "",
                "power-saver": ""
            }
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


### ~/.config/waybar/style.css

    *{
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
        color: #888888;
        /*	margin: 0 1px;*/
    }
    #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
    
    }
    
    #workspaces button.visible {
        padding: 0 5px;
        border-radius: 10px;
        color: #ff0000;
        margin: 0 0px;
    }
    
    #workspaces button.focused {
        color: #00ff00;
    
    }
    #workspaces button.urgent {
        background: #5555ff;
    
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


### waybar utility scripts

1.  ~/bin/sway/waybar-bluetooth

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

2.  ~/bin/sway/waybar-dropbox-json

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

3.  ~/bin/sway/waybar-dropbox-status

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

4.  ~/bin/sway/waybar-ip-info-json

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

5.  ~/bin/sway/waybar-monitors

        #!/usr/bin/env bash
        #Maintained in linux-config.org
        l=$(swaymsg -t get_outputs | jq  -r '[ .[] | select(.dpms and .active) ] | length')
        o=$(swaymsg -t get_outputs | jq  -r '. | map(.name) | join(",")')
        t=""
        for i in `seq $l`; do t="${t} ⃢ ";done
        text="{\"text\":\""$t"\",\"tooltip\":\""$o"\"}"
        echo $text

6.  ~/bin/sway/waybar-network-applet

        #!/usr/bin/env bash
        #Maintained in linux-config.org
        if command -v iwgtk 2>&1 >/dev/null
        then
            pgrep iwgtk || iwgtk -i &
        else
            pgrep nm-applet || nm-applet &
        fi

7.  ~/bin/sway/waybar-power-draw

        #!/usr/bin/env bash
        # Maintained in linux-config.org
        awk '{print $1*10^-6 "W "}' /sys/class/power_supply/BAT0/power_now

8.  ~/bin/sway/waybar-weather-json

        #!/usr/bin/env bash
        # Maintained in linux-config.org 
        sleep 5
        WTTR_LOCATION="${1:-"Grömitz,DE"}"  waybar-wttr

9.  ~/bin/sway/waybar-wttr

        #!/usr/bin/env python
        # Maintained in linux-config.org
        
        import json
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
        
        
        weather = requests.get("https://wttr.in/?format=j1").json()
        
        
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
        
        
        data['text'] = WEATHER_CODES[weather['current_condition'][0]['weatherCode']] + \
            " "+weather['current_condition'][0]['FeelsLikeC']+"°"
        
        data['tooltip'] = f"<b>{weather['current_condition'][0]['weatherDesc'][0]['value']} {weather['current_condition'][0]['temp_C']}°</b>\n"
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


## swaywm scripts     :sway:wayland:


### ~/bin/sway-active-monitors-count

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    swaymsg -t get_outputs | jq  -r '[ .[] | select(.dpms and .active) ] | length'


### ~/bin/sway/sway-active-monitor-ids

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    swaymsg -t get_outputs | jq  -r 'sort_by(.rect.x) | .[] | select(.dpms and .active) | .name'


### ~/bin/sway/sway-active-monitor-names

    #!/usr/bin/env bash
    # Maintained in linux-config.org
     swaymsg -t get_outputs | jq  -r 'sort_by(.rect.x) | .[] |  select(.dpms and .active)|(.make + " " + .model + " " + .serial)'


### ~/bin/sway/sway-autostart

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    if [ -f "${HOME}/.SWAY_START" ] && [ -z "$SSH_CONNECTION" ]; then
        if  [ "$(hostname)" = "xmgneo" ];then
            sway --my-next-gpu-wont-be-nvidia &
        else
            sway &
        fi
    fi


### ~/bin/sway/sway-brightness-notify

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway-notify "☼:$(printf "%.0f" `brightnessctl g`)"


### ~/bin/sway/sway-bluetooth

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    exec sway-oneterminal "bluetoothctl" "bluetoothctl"


### ~/bin/sway/sway-do-tool

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    
    # NB ths is currently lazy. It uses brute force, and i need to do some get_tree jq stuff instead to
    # get the app_id/class instance instead. But.. it works.
    id="$1"
    script="$2"
    [ -z "$id" ] && echo "usage: sway-do-tool id" && exit 1
    if swaymsg "[title=${id}] focus" &> /dev/null; then
        :
    else
        if  swaymsg "[class=${id}] focus" &> /dev/null; then
            :
        else
            if  swaymsg "[app_id=${id}] focus" &> /dev/null; then
                :
            else
                if [ ! -z "$script" ]; then
                    eval "$script" &
                else
                    exit 1
                fi
            fi
        fi
    fi
    exit 0


### ~/bin/sway/sway-oneterminal

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    
    sessionname="${1:-`pwd`}"
    title="${ONETERM_TITLE:-${sessionname}}"
    script="${2}"
    if ! sway-do-tool "$title"; then
        kitty --title "${title}" -e tmux new-session -A -s ${sessionname} ${script} &
    else
        if ! tmux has-session -t  "${sessionname}"; then
            tmux attach -t "${sessionname}"
        fi
    fi
    exit 0


### ~/bin/sway/sway-dpms

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    DPMS="${1:-on}"
    DISP="${2:-*}"
    currentDPMS="$(swaymsg -t get_outputs | jq -r '.[0]'.dpms)"
    [ "$dpms" != "$currentDPMS" ] && swaymsg "output $DISP DPMS $DPMS"


### ~/bin/sway/sway-htop

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    exec sway-oneterminal "Processes" btop


### ~/bin/sway/sway-kanshi

Monitor control with hotplug <https://github.com/emersion/kanshi>
Load a host specific kanshi file if it exists

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    # pidof kanshi && echo "kanshi process $(pidof kanshi) already running. Exiting." && exit 0
    pkill kanshi
    config="${HOME}/.config/kanshi/config-$(hostname)"
    if [ -f  "$config" ]; then
        echo  "kanshi -c $config"
        kanshi -c "$config"
    else
        echo "kanshi default config"
        kanshi
    fi

1.  config

        profile {
        output eDP-1 enable position 0,0
        }

2.  config-um690

        {
        output HDMI-A-1  enable mode 2560x1440 position 0,0
        output HDMI-A-2  enable mode 1920x1080 position 2560,116
        }

3.  config-t14s

        profile home-dp{
        output 'ASUSTek COMPUTER INC ASUS PB278QV 0x00030ADB' mode 2560x1440 position 0,0
        output 'Synaptics Inc Non-PnP 0x00BC614E' mode 1920x1080 position 2560,0
        output 'AU Optronics 0x573D Unknown' mode 1920x1080 position 3000,1080
        }
        profile home-hdmi{
        output 'ASUSTek COMPUTER INC ASUS PB278QV 0x00030ADB' mode 2560x1440 position 0,0
        output 'HKC OVERSEAS LIMITED 22N1 0000000000001' mode 1920x1080 position 2560,0
        output 'AU Optronics 0x573D Unknown' mode 1920x1080 position 3000,1080
        }
        profile home-no-lap{
        output 'ASUSTek COMPUTER INC ASUS PB278QV 0x00030ADB' mode 2560x1440 position 0,0
        output 'HKC OVERSEAS LIMITED 22N1 0000000000001' mode 1920x1080 position 2560,0
        }

4.  config-xmgneo

        {
        output eDP-1 enable enable mode 2560x1440  position 0,0
        }
        
        {
        output eDP-1 enable mode 2560x1440 position 2560,0
        output HDMI-A-1  enable mode 2560x1440 position 0,0
        }
        
        {
        output eDP-1 enable mode 2560x1440 position 2560,0
        output DP-1  enable mode 2560x1440 position 0,0
        }

5.  config-thinkpadt460

        profile {
        output eDP-1 enable mode 1366×768   position 0,0
        }
        
        profile {
        output eDP-1 enable mode 1366×768  position 1920,0
        output DP-4 enable mode 1920x1080 position 0,0
        }

6.  config-x1c6

        profile {
        output eDP-1 enable mode 1920x1080  position 0,0
        }
        
        profile {
        output eDP-1 disable
        output DP-1 enable mode 2560x1440 position 0,0
        }
        
        profile {
        output eDP-1 disable
        output HDMI-A-1 enable mode 2560x1440 position 0,0
        }

7.  config-x13amdg4

        profile {
        output eDP-1 enable mode 1920x1200  position 0,0
        }


### ~/bin/sway/sway-lock-utils

Just a gathering place of locky/suspendy type things&#x2026;

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    lock() {
        pidof swaylock || swaylock -f -i ~/Pictures/LockScreen/current -s fill -c 000000
        sway-notify "unlocked"
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


### swayidle, ~/bin/sway/sway-idle     :sleep:lock:idle:

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    pkill swayidle
    exec swayidle -w \
         timeout 1 '' \
         resume 'sway-lock-utils unblank' \
         timeout 10 'pidof swaylock && sway-lock-utils blank' \
         resume 'sway-lock-utils unblank' \
         timeout ${SWAYIDLEHOOK_BLANK:-3600} 'sway-lock-utils blank' \
         resume 'sway-lock-utils unblank' \
         timeout ${SWAYIDLEHOOK_LOCK:-14400} 'sway-lock-utils lock' \
         resume 'sway-lock-utils unblank' \
         timeout ${SWAYIDLEHOOK_SUSPEND:-0} 'sway-lock-utils suspend' \
         resume 'sway-lock-utils unblank' \
         lock 'sway-lock-utils lock' \
         unlock 'sway-lock-utils unblank' \
         before-sleep 'sway-lock-utils lock'

1.  SWAY-IDLE DEFAULTS

    Not exported : add to .profile.local
    
        export SWAYIDLEHOOK_BLANK=300
        export SWAYIDLEHOOK_LOCK=3600
        export SWAYIDLEHOOK_SUSPEND=0


### ~/bin/sway/sway-laptop-id

Here we look for an env `LAPTOP_ID`. In my setup that would be set in `${HOME}/.profile.local`. If thats not set we assume `eDP-1`
but in both cases we check if it exists in the sway tree, and, if not, set it t the last

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    id="${LAPTOP_ID:-'eDP-1'}"
    id=$( swaymsg -t get_outputs | jq -r ".[] | select (.name == \"${id}\") | .name")
    if [ -z  "$id" ];then
        id=$(swaymsg -t get_outputs | jq -r '.[-1].name')
    fi
    echo $id


### ~/bin/sway/sway-lock

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway-lock-utils lock


### ~/bin/sway/sway-blank

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway-lock-utils blank


### ~/bin/sway/sway-notify

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    notify-send -t ${2:-5000} "${1}" || true


<a id="org54adcd1"></a>

### ~/bin/sway/sway-screen

`enable` or `disable`. Won't allow you to turn off the sole enabled display.

:ID:       82455cae-1c48-48b2-a8b3-cb5d44eeaee9

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    m="${2:-$(swaymsg -t get_outputs | jq -r '.[0].name')}"
    c="${1:-enable}"
    [ "$c" = "disable" ] && [ "$(sway-active-monitors-count)" = "1" ] && sway-notify "Not turning off single display $m" && exit 1
    swaymsg "output ${m} ${c}"
    (sleep 2 && sway-notify "${m}:${c}") &


### ~/bin/sway/sway-workspace-position

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    mapfile -t outputs  < <( sway-active-monitor-ids )
    export leftOutput=${outputs[0]}
    export rightOutput=${outputs[1]}
    export rightMostOutput=${outputs[2]}
    
    rightOutput=${rightOutput:-${leftOutput}}
    rightMostOutput=${rightMostOutput:-${rightOutput}}
    
    sway-notify "Left:${leftOutput}, Right:${rightOutput}, Rightmost: ${rightMostOutput}"
    curr=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .name')
    
    # swaymsg "output * bg ~/Pictures/Wallpapers/current fill"
    swaybg -o $leftOutput -i ${HOME}/Pictures/Wallpapers/s1 -m fill &
    
    if [ "$leftOutput" != "$rightOutput" ]; then
        swaybg -o  ${rightOutput} -i ${HOME}/Pictures/Wallpapers/s2 -m fill &
        if [ "$rightOutput" != "${rightMostOutput}" ]; then
            swaybg -o ${rightMostOutput} -i ${HOME}/Pictures/Wallpapers/s3 -m fill  &
        fi
    fi
    
    swaymsg "
       workspace 1; move workspace to output $leftOutput;
       workspace 2; move workspace to output $rightOutput;
       workspace 3; move workspace to output $leftOutput;
       workspace 4; move workspace to output $rightOutput;
       workspace 5; move workspace to output $rightOutput;
       workspace 6; move workspace to output $rightMostOutput;
       workspace 7; move workspace to output $rightMostOutput;
       workspace 8; move workspace to output $rightMostOutput;
       workspace $curr;
     "


### ~/bin/sway/sway-workspace-populate

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    swaymsg "workspace 8; layout stacking;sleep 0.3;"
    sway-www "https://web.whatsapp.com/"
    sway-www "https://web.telegram.org/k/"
    sway-www "https://reddit.com/"
    sway-www "https://mail.google.com/mail/u/0/#inbox"
    sleep 0.3


### ~/bin/sway/sway-workspace-populate-conditional

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    if [ -f "${HOME}/.sway-workspace-populate" ]; then
        sway-workspace-populate
    elif [ -f "${HOME}/.sway-workspace-populate-user" ]; then
        source "${HOME}/.sway-workspace-populate-user"
    # else
    #     emacsclient -c -a "" &
    fi


### ~/bin/sway/sway-screen-menu

Gui to select a display and enable/disable it. Calls down to [~/bin/sway/sway-screen](#org54adcd1).

:ID:       82455cae-1c48-48b2-a8b3-cb5d44eeaee9

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


### ~/bin/sway/sway-display-swap

<https://i3wm.org/docs/user-contributed/swapping-workspaces.html>

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


### ~/bin/sway/sway-launcher-wofi

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    exec dmenu_path | wofi --show drun,dmenu -i | xargs swaymsg exec --


### ~/bin/sway/sway-launcher-rofi

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    exec rofi -combi-modi window,drun,ssh,run -show combi -show-icons


### ~/bin/sway/sway-launcher-fzf

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    exec kitty --title "sway-launcher" -e bash -c "dmenu_path | fzf | xargs swaymsg exec"


### ~/bin/sway/sway-launcher-ulauncher

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    if ! pgrep "ulauncher"; then
        ulauncher
    else
        ulauncher-toggle
    fi


### ~/bin/sway/sway-launcher

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway-launcher-fzf


### ~/bin/sway/sway-screenshot

Thanks: <https://www.reddit.com/r/linuxmasterrace/comments/k1bjkp/i_wrote_a_trivial_wrapper_for_taking_screenshots/>

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    # thanks to: https://www.reddit.com/r/linuxmasterrace/comments/k1bjkp/i_wrote_a_trivial_wrapper_for_taking_screenshots/
    
    DIR=${HOME}/tmp/Screenshots
    
    mkdir -p "${DIR}"
    
    FILENAME="screenshot-$(date +%F-%T).png"
    sway-notify "use the mouse to select region.."
    region="$(slurp)"
    if [ ! -z "$region" ]; then
        sway-notify "Taking pic in 5s.."
        sleep 5
        grim -g "$region" "${DIR}"/"${FILENAME}" || exit 1
        #Create a link, so don't have to search for the newest
        ln -sf "${DIR}"/"${FILENAME}" "${DIR}"/screenshot-latest.png
        sway-notify "Done! see ${DIR}/screenshot-latest.png"
    fi


### ~/bin/sway/sway-screen-recorder

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    if pgrep -x "wf-recorder"; then
        sway-notify "stopping wf-recorder"
        # sigint
        kill -2 $(pgrep wf-recorder)
    else
        sway-notify "starting wf-recorder"
        wf-recorder -f ${HOME}/tmp/output.mkv -g "$(slurp)"
    fi


### ~/bin/sway/sway-volume-notify

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    if [[ "$1" = "0" ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    elif [[ "$1" =  "+" ]]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "0.1+"
    elif [[ "$1" = "-" ]]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "0.1-"
    fi
    
    
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    volumep=$(echo $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | tr -dc '0-9')| sed 's/^0*//')
    if [[ -z $volumep ]]; then
        volumep="0"
    elif [[ $volumep -gt "150" ]];then
        volumep="150"
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 1
    fi
    if [[ "$volume" == *"MUTED"* ]]; then
        sway-notify "🔊 MUTED (${volumep}%) "
    else
        sway-notify "🔊${volumep}%"
    fi


### ~/bin/sway/sway-weather

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway-www "https://www.accuweather.com/en/de/gr%C3%B6mitz/23743/hourly-weather-forecast/176248"


### sway-nvidia     :nvidia:dgpu:

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway --my-next-gpu-wont-be-nvidia "$@"


### ~/bin/sway/sway-www

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway-chrome "$@" &


### ~/bin/sway/sway-email

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    MOZ_ENABLE_WAYLAND=1 firefox --name=wwwemail --new-window "https://www.gmail.com" &


### ~/bin/sway/sway-chrome

    #!/usr/bin/env bash
    # Maintained in linux-config.org
     google-chrome --hide-crash-restore-bubble --new-window "$@"  &


### ~/bin/sway/sway-firefox

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    MOZ_ENABLE_WAYLAND=1 firefox --new-window "$1" &>/dev/null &


### ~/bin/sway/sway-wifi

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sway-oneterminal "wifi" "nmtui"  &>/dev/null


## wayland utils


### mako notificiation

    default-timeout=10000


### wlogout

1.  readme

        Layout maintained in linux-config.org
        https://github.com/ArtsyMacaw/wlogout/blob/master/layout

2.  layout config

        {
        "label" : "lock",
        "action" : "sway-lock-utils lock",
        "text" : "Lock(l)",
        "keybind" : "l"
        }
        {
        "label" : "blank",
        "action" : "sway-lock-utils blank",
        "text" : "Blank(b)",
        "keybind" : "b"
        }
        
        {
        "label" : "logout",
        "action" : "sway-lock-utils logout",
        "text" : "Logout(e)",
        "keybind" : "e"
        }
        {
        "label" : "suspend",
        "action" : "sway-lock-utils suspend",
        "text" : "Suspend(s)",
        "keybind" : "s"
        }
        
        {
        "label" : "reboot",
        "action" : "sway-lock-utils reboot",
        "text" : "Reboot(r)",
        "keybind" : "r"
        }
        {
        "label" : "shutdown",
        "action" : "sway-lock-utils shutdown",
        "text" : "Shutdown(S)",
        "keybind" : "S"
        }

3.  layout style

        * {
                background-image: none;
                box-shadow: none;
        }
        
        window {
                background-color: rgba(12, 12, 12, 0.9);
        }
        
        button {
            border-radius: 0;
            border-color: black;
                text-decoration-color: #FFFFFF;
            color: #FFFFFF;
                background-color: #1E1E1E;
                border-style: solid;
                border-width: 1px;
                background-repeat: no-repeat;
                background-position: center;
                background-size: 25%;
        }
        
        /* button:focus, button:active, button:hover { */
        /* 	background-color: #3700B3; */
        /* 	outline-style: none; */
        /* } */
        
        #lock {
            background-image: image(url("/usr/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
        }
        
        #blank {
            background-image: image(url("blank.png"),url("blank.png"));
        }
        
        #logout {
            background-image: image(url("/usr/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
        }
        
        #suspend {
            background-image: image(url("/usr/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
        }
        
        #hibernate {
            background-image: image(url("/usr/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
        }
        
        #shutdown {
            background-image: image(url("/usr/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
        }
        
        #reboot {
            background-image: image(url("/usr/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
        }


# Programming Related     :programming:


## clang-format

clangd lsp formatting

    # Maintained in linux-config.org
    BasedOnStyle: Google
    Language: Cpp
    IndentWidth: 4
    AllowShortBlocksOnASingleLine: false
    AllowShortCaseLabelsOnASingleLine: false
    AllowShortFunctionsOnASingleLine: false
    AllowShortIfStatementsOnASingleLine: false
    AllowShortLoopsOnASingleLine: false
    AccessModifierOffset: -4
    PointerAlignment: Left
    ColumnLimit: 80
    KeepEmptyLinesAtTheStartOfBlocks: true


## dart/flutter     :dart:flutter:

<https://dart.dev/get-dart#install-a-debian-package>
<https://docs.flutter.dev/get-started/install/linux>


### path

    export PATH="${HOME}/bin/thirdparty/flutter/bin:$PATH"


## llvm     :llvm:


### path

    export PATH="${HOME}"/bin/llvm:"${HOME}"/bin/llvm/build/bin:"$PATH"


### lldb     :lldb:

1.  ~/.lldbinit

        # Maintained in linux-config.org
        
        #settings write -f .lldb-settings-local-start
        #settings read  -f .lldb-settings-local
        
        settings set target.load-cwd-lldbinit true
        settings set interpreter.prompt-on-quit false
        settings set target.x86-disassembly-flavor intel
        
        command alias bfl breakpoint set -f %1 -l %2
        command alias lv command script import "~/bin/thirdparty/pyenv/versions/3.9.2/lib/python3.9/site-packages/voltron/entry.py"
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

2.  scripts

    1.  ~/bin/llvm/disassembly\_mode.py
    
        [disassembly\_mode.py](directories/bin/lldb/disassembly_mode.py)
    
    2.  ~/bin/llvm/lldb-ui-session
    
        Create a session but let someone else do the attach
        
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
    
    3.  ~/bin/llvm/lldb-ui
    
            #!/usr/bin/env bash
            # Maintained in linux-config.org
            directory="${1:-`pwd`}"
            session="$(lldb-ui-session "${directory}" "$2")"
            ONETERM_TITLE="dbg:lldb-$session"  sway-oneterminal "$session"
    
    4.  lldb voltron scripts
    
        1.  ~/bin/llvm/voltron-backtrace
        
                #!/usr/bin/env bash
                # Maintained in linux-config.org
                voltron v c 'thread backtrace'
        
        2.  ~/bin/llvm/voltron-breakpoints
        
                #!/usr/bin/env bash
                # Maintained in linux-config.org
                voltron v c 'breakpoint list'
        
        3.  ~/bin/llvm/voltron-disassembly
        
                #!/usr/bin/env bash
                # Maintained in linux-config.org
                voltron v c 'disassemble --pc --context '"${1:-4}"' --count '"${2:-4}"''
        
        4.  ~/bin/llvm/voltron-disassembly-mixed
        
                #!/usr/bin/env bash
                # Maintained in linux-config.org
                voltron v c 'disassemble --mixed --pc --context '"${1:-1}"' --count '"${2:-32}"''
        
        5.  ~/bin/llvm/voltron-locals
        
                #!/usr/bin/env bash
                # Maintained in linux-config.org
                voltron v c 'frame variable' --lexer c
        
        6.  ~/bin/llvm/voltron-registers
        
                #!/usr/bin/env bash
                # Maintained in linux-config.org
                voltron v registers
        
        7.  ~/bin/llvm/voltron-source
        
                #!/usr/bin/env bash
                # Maintained in linux-config.org
                voltron v c 'source list -a $rip -c '"${1:-32}"''
        
        8.  ~/bin/llvm/voltron-stack
        
                #!/usr/bin/env bash
                # Maintained in linux-config.org
                voltron v stack
    
    5.  lldb python scripting     :python:
    
        lldb also has a built-in Python interpreter, which is accessible by the “script” command. All the functionality of the debugger is available as classes in the Python interpreter, so the more complex commands that in gdb you would introduce with the “define” command can be done by writing Python functions using the lldb-Python library, then loading the scripts into your running session and accessing them with the “script” command.
        
        <https://lldb.llvm.org/use/python.html>
        
        1.  TODO follow up on SE post
        
            <https://stackoverflow.com/questions/68207020/trying-to-run-pdb-in-an-imported-lldb-python-script-results-in-error-attributeer>


## gdbgui

<https://www.gdbgui.com/>


### fix for python 3.9

    export PURE_PYTHON=1


## haskell

    # haskell
    #source "${HOME}/.ghcup/env"


## python


### pyvenv  <https://github.com/pyenv/pyenv#installation>

1.  add pyenv to path

        export PYENV_ROOT="${HOME}/bin/thirdparty/pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"


### Debuggers     :debuggers:

1.  pdb     :pdb:

    <https://docs.python.org/3/library/pdb.html>
    The official python debugger
    [/home/rgr/development/projects/Python/debugging/pdb](file:///home/rgr/development/projects/Python/debugging/pdb)

2.  ipdb     :ipdb:

    <https://pypi.org/project/ipdb/>
    
    1.  installing
    
            pip install ipdb
    
    2.  Better Python Debugging
    
        <https://hasil-sharma.github.io/2017-05-13-python-ipdb/>
    
    3.  ~/.ipdb
    
            # Maintained in linux-config.org
            context=5


## platformio     :platformio:

    # platformio integration - point to pio ide (vscode) stuff.
    export PATH="${PATH}:${HOME}/.platformio/penv/bin"


## Android     :android:


### Sdk     :sdk:

    # android sdk
    export ANDROID_HOME="${HOME}/development/Android/Sdk"
    export PATH="${PATH}:${ANDROID_HOME}/emulator"
    export PATH="${PATH}:${ANDROID_HOME}/platform-tools"
    
    export ANDROID_STUDIO_HOME="${HOME}/bin/thirdparty/android-studio"
    export PATH="${PATH}:${ANDROID_STUDIO_HOME}/bin"


## node.js


### nvm

[nvm](https://github.com/nvm-sh/nvm#installing-and-updating) allows you to quickly install and use different versions of node via the command line.

    lts/*

    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


### snap

    export PATH="/snap/bin:$PATH"


## stm32     :embedded:stm32:


### stm32cubeide     :stm32cubeide:

1.  path

        # platformio integration - point to pio ide (vscode) stuff.
        export PATH="${PATH}:${HOME}/bin/thirdparty/stm32cubeide_1.9.0"

2.  install / uninstall

        #!/usr/bin/env bash
        #Maintained in linux-config.org
        version="${1:-${STM32CUBEIDE_VERSION:-"1.9.0"}}"
        echo "Removing st-stm32cubeide-${version}"
        sudo dpkg -r st-stm32cubeide-"$version"
        sudo dpkg -r st-stlink-server
        sudo dpkg -r st-stlink-udev-rules
        sudo dpkg -r segger-jlink-udev-rules

3.  STM32CubeMX app

    This is a bit defunct now (may 2022) as they have packaged their code into exes. Also there is a wayland exe.
    
    :ID:       b9b221b0-510f-415b-8819-c96b6e00a1d9
    :header-args:tangle: no
    
        #!/usr/bin/env bash
        #Maintained in linux-config.org
        java -jar ~/bin/thirdparty/STM32CubeMX/STM32CubeMX
    
    1.  sway
    
            for_window [class="STM32CubeIDE"] floating enable
            assign [class="STM32CubeIDE"] 3
            assign [title="STM32CubeIDE"] 3

4.  launcher for X11 compatability

    pending deletion
    
        #!/usr/bin/env bash
        # Maintained in linux-config.org
        JAVA_AWT_WM_NONREPARENTING=1 GDK_BACKEND=x11 exec "/opt/st/stm32cubeide_${STM32CUBEIDE_VERSION:-"1.7.0"}/stm32cubeide"


# PGP/GNUPG/GPG


## ~/.gnupg/gpg.conf

    # Maintained in linux-config.org
    use-agent


## ~/.gnupg/gpg-agent.conf

    # Maintained in linux-config.org
    #gpg-preset-passphrase
    allow-preset-passphrase
    pinentry-program /usr/bin/pinentry
    max-cache-ttl 86400
    default-cache-ttl 86400
    max-cache-ttl-ssh 86400
    default-cache-ttl-ssh 86400
    enable-ssh-support


## ~/.profile

    export USER_STARTX_START=


## ~/.profile.local

potentially need some gpg keys : not tangled


### keys     :crypt:

&#x2013;&#x2014;BEGIN PGP MESSAGE&#x2013;&#x2014;
hQEMA7IjL5SkHG4iAQgAnAMLgodgtOc1tsGz6mRqJbkJsM+R+5MTPdsOdml6xMoL
xFZjkYTDUGa3G6PsQHpbJ/tjD+6B4qmZIymq1EReWPtrepGGN6DNG8hLPVNnQ+9N
WAFaK1o+gzzfsw9XuptT5Um47k2G3zm019mGKDe0OwYJJ/r/DTHpz9yI9nj5lVdq
sdk0Y/WQL/5mcraC7LPz0FhIhuXqKKFNvcQCA6D0fTWJxlzqvXRzuc44LN+mvozq
9Q4WbvXp/etZjeiUYjXmz70KEYxFIch3OR4EGmV41apfojLTmR9R2dp/u3jYexMy
NlXugS5egyP+ioiuuTcCsSjN4rxnDwSW868lLkdhIdLAPgFdxEWpJjtaJO0A9aIB
6lJTRLKPzuwTyGiyRdKO8yqYFYwllgfEr/87qcB/ajjRpkhw9tlD8zTrODt4ZUu2
MQQHK2rzvplmgDf2LvDMiM2gv7z4bI3YzOTiGu6m+SxW/j8LA71WRMwhFmUObgOb
g44XzdKHAV0o0Q/ZPPnJU4dlKc9nRkNS3MzpORmUGAT1/FSwt+q7uzpuBTZ1crGl
P/fo8sDBBu2QBoL2+gQZ11l7uSZMjTCR/8msBO5LbLDmyOUposbv6va1dzPN898F
ZsaqN9VNjV2b75kQiPJsZaoekClV7yOFc10/VRKBFD1MlspEovrIpReI9by6azIU
=nb0T
&#x2013;&#x2014;END PGP MESSAGE&#x2013;&#x2014;


# Email Related


## mu4e  - mu for Emacs

[mu4e](https://www.djcbsoftware.nl/code/mu/mu4e.html), a Maildir based email client for Emacs, is configured in my [emacs-config](https://github.com/rileyrg/Emacs-Customisations)


## Maildir sync using [mbsync](https://wiki.archlinux.org/index.php/Isync) inspired by the [SystemCrafters](https://www.youtube.com/watch?v=yZRyEhi4y44&ab_channel=SystemCrafters&loop=0) video.

maildir sync using mbsync


### install isync and mu4e

mu4e includes [mu](https://www.djcbsoftware.nl/code/mu/mu4e/Indexing-your-messages.html) for indexing.

    sudo apt install isync mu4e


### mbsync config

Note the [PassCmd](https://wiki.archlinux.org/index.php/Isync) - since I use gpg then that's the way to go.

    # Maintained in linux-config.org
    Create  Both
    Expunge Both
    SyncState *
    
    IMAPAccount gmx
    Host imap.gmx.com
    User rileyrg@gmx.de
    PassCmd "pass Email/gmx/apps/mbsync"
    TLSType IMAPS
    CertificateFile /etc/ssl/certs/ca-certificates.crt
    PipelineDepth 1
    
    IMAPStore gmx-remote
    Account gmx
    
    MaildirStore gmx-local
    Path ~/Maildir/gmx/
    Inbox ~/Maildir/gmx/INBOX
    SubFolders Legacy
    
    Channel gmx-inbox
    Far :gmx-remote:"INBOX"
    Near :gmx-local:"INBOX"
    
    Channel gmx-sent
    Far :gmx-remote:"Gesendet"
    Near :gmx-local:"Sent"
    
    Channel gmx-learning
    Far :gmx-remote:"Learning"
    Near :gmx-local:"Learning"
    
    Channel gmx-drafts
    Far :gmx-remote:"Entw&APw-rfe"
    Near :gmx-local:"Drafts"
    
    Channel gmx-bin
    Far :gmx-remote:"Gel&APY-scht"
    Near :gmx-local:"Bin"
    
    Channel gmx-spam
    Far :gmx-remote:"Spamverdacht"
    Near :gmx-local:"Spam"
    
    Channel gmx-archive
    Far :gmx-remote:"Archiv"
    Near :gmx-local:"Archive"
    
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
    TLSType IMAPS
    CertificateFile /etc/ssl/certs/ca-certificates.crt
    PipelineDepth 32
    
    IMAPStore gmail-remote
    Account gmail
    
    MaildirStore gmail-local
    Path ~/Maildir/gmail/
    Inbox ~/Maildir/gmail/INBOX
    SubFolders Legacy
    
    Channel gmail-inbox
    Far :gmail-remote:"INBOX"
    Near :gmail-local:"INBOX"
    
    Channel gmail-sent
    Far :gmail-remote:"[Google Mail]/Sent Mail"
    Near :gmail-local:"Sent"
    
    Channel gmail-drafts
    Far :gmail-remote:"[Google Mail]/Drafts"
    Near :gmail-local:"Drafts"
    
    Channel gmail-bin
    Far :gmail-remote:"[Google Mail]/Bin"
    Near :gmail-local:"Bin"
    
    Channel gmail-spam
    Far :gmail-remote:"[Google Mail]/Spam"
    Near :gmail-local:"Spam"
    
    Channel gmail-archive
    Far :gmail-remote:"[Google Mail]/All Mail"
    Near :gmail-local:"Archive"
    
    Channel gmail-gmx-archive
    Far :gmail-remote:"[Google Mail]/All Mail"
    Near :gmx-local:"gmail/Archive"
    
    Group gmail
    Channel gmail-inbox
    Channel gmail-sent
    Channel gmail-drafts
    Channel gmail-bin
    Channel gmail-spam
    Channel gmail-archive
    
    Group gmail-gmx
    Channel gmail-gmx-archive


### sync and index

    cd ~
    mkdir -p ~/Maildir/gmail
    mkdir -p ~/Maildir/gmx
    mbsync gmail gmx
    mu init --maildir=~/Maildir --my-address="riley**@gmx.de" --my-address="riley**@gmail.com"
    mu index


### mbsync services

1.  ~/.config/systemd/user/mbsync.timer

        [Unit]
        Description=Mailbox synchronization timer
        
        [Timer]
        OnBootSec=60
        OnUnitActiveSec=3600
        Unit=mbsync.service
        
        [Install]
        WantedBy=timers.target

2.  ~/.config/systemd/user/mbsync.service

        [Unit]
        Description=Mailbox synchronization service
        
        [Service]
        Type=simple
        ExecStart=/home/rgr/bin/getmails
        
        RuntimeMaxSec=1200
    
    and activate them
    
        systemctl --user enable mbsync.timer
        systemctl --user start mbsync.timer


## ~/bin/getmails

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    if ! $(pidof -xq "mbsync"); then
        if [ $# -eq 0 ]; then
            mbsync -a
        else
            mbsync "$@"
        fi
    fi
    exit 0


# bin


## ~/bin/arch-backup

keep the arch and aur packages installed backed up

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    pacman -Qqen > ~/cloud/homefiles/etc/arch/pkglist-repo.txt
    pacman -Qqem > ~/cloud/homefiles/etc/arch/pkglist-aur.txt


## ~/bin/arch-restore

install packages from backup catalog

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    sudo pacman -S --needed - < ~/cloud/homefiles/etc/arch/pkglist-repo.txt
    pikaur -S --needed - < ~/cloud/homefiles/etc/arch/pkglist-aur.txt


## ~/bin/beepy

    if [ -f /usr/share/sounds/freedesktop/stereo/suspend-error.oga ];then
        paplay  /usr/share/sounds/freedesktop/stereo/suspend-error.oga
    else
        # sudo modprobe pcspkr
        beep
    fi


## ~/bin/bluetooth-headphone-controls

Enable bluetooth multimedia pause/ play

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    pkill mpris-proxy
    mpris-proxy


## ~/bin/edit

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    ${VISUAL:-${EDITOR:-vi}} "${@}"


## ~/bin/eman

Use emacs for manpages if it's running
might be an idea set an alias such as 'alias man=eman'

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    mp="${1:-man}"
    if pidof emacs; then
        emacsclient -c -e "(manual-entry \"-a ${mp}\")" &> /dev/null &
    else
        sway-oneterminal random-man "man $mp"
    fi


## ~/bin/expert-advice

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    f=$(command -v fortune &>/dev/null && fortune || echo "I don't need to study a subject to have my own truths. Because own truths ARE a thing in 2020.")
    if [ "$1" = "t" ]
    then
        echo $f | xclip -i -selection clipboard
    fi
    echo $f


## ~/bin/extract-debug-info

strip debug info and store elsewhere

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


## ~/bin/htop-regexp

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
    ONETERM_TITLE="filtered htop:${filter}" sway-oneterminal "${session}"


## ~/bin/make-compile\_commands

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    make --always-make --dry-run \
        | grep -wE 'gcc|g++' \
        | grep -w '\-c' \
        | jq -nR '[inputs|{directory:".", command:., file: match(" [^ ]+$").string[1:]}]' \
             > compile_commands.json


## ~/bin/md-read

     #!/usr/bin/env bash
     #Maintained in linux-config.org
    [ -z  $(command -v lynx) ] && echo "install lynx" && exit 1
    [ -z  $(command -v pandoc) ] && echo "install pandoc" && exit 1
    pandoc "$1" | lynx -stdin


## ~/bin/random-man-page

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    page="$(find /usr/share/man/man1 -type f | sort -R | head -n1)"
    eman "$page"


## ~/bin/remove-broken-symlinks

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    find -L . -name . -o -type d -prune -o -type l -exec rm {} +


## ~/bin/remove-conflicted-copies

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


## ~/bin/resgithub.sh

[resgithub.sh - reset local and remote git repo](https://github.com/rileyrg/resgithub)

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
    #    git push -f
    else
        echo "test Warning: No git config file found. Aborting.";exit;
    fi


## ~/bin/rsnapshot-if-mounted

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


## ~/cloud/etc/rsnapshot/excludes

    #Maintained in linux-config.org
    - /home/rgr/.local/share/Steam/
    - /home/rgr/Mail/
    - /home/rgr/Maildir/
    - OpenAudible/aax/
    - OpenAudible/books/
    - OpenAudible/current/
    - cloud/.syncrclone/
    - .syncrclone/logs/
    - .syncrclone/backups/


## ~/bin/sharemouse

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    exec ssh -X ${1-192.168.2.100} x2x -east -to :0


## ~/bin/wifi-toggle

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


## ~/bin/enable-disable-wifi

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    
    if LANG=C nmcli dev | grep -q '\sethernet\s\+connected\s'; then
        if [ -f "${HOME}"/.wifi-and-eth ]; then
            echo "${HOME}/.wifi-and-eth exists so wifi on."
            nmcli radio wifi on
        else
            echo "Turning wifi  off"
            nmcli radio wifi off
        fi
    else
        echo "Turning wifi on"
        nmcli radio wifi on
    fi


## ~/bin/70-wifi-wired-exclusive.sh

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    # https://askubuntu.com/a/1272865/232407
    export LC_ALL=C
    
    # This dispatcher script makes Wi-Fi mutually exclusive with wired networking. When a wired
    #    interface is connected, Wi-Fi will be set to airplane mode (rfkilled). When the wired
    #    interface is disconnected, Wi-Fi will be turned back on. Name this script e.g.
    #    70-wifi-wired-exclusive.sh and put it into /etc/NetworkManager/dispatcher.d/ directory.
    #    See NetworkManager(8) manual page for more information about NetworkManager dispatcher
    #    scripts.
    
    if [ "$2" = "up" ]; then
        enable-disable-wifi
    fi
    
    if [ "$2" = "down" ]; then
        enable-disable-wifi
    fi


## ~/bin/upd

update sw

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    string="$(uname -r)"
    if [[ $string == *"arch"* ]]; then
        if command -v "pikaur"; then
            pikaur -Syu
        else
            sudo pacman -Syu
        fi
    else
        export DEBIAN_FRONTEND=noninteractive
        sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y
    fi


## rclone

<https://rclone.org/>


### ~/bin/syncrclone-gdrive-docs

<https://github.com/Jwink3101/syncrclone>

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    syncrclone "$HOME"/.syncrclone/gdrive-docs-config.py


### ~/bin/syncrclone-gdrive

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    syncrclone "$HOME"/.syncrclone/gdrive-config.py


### ~/bin/hetzner-du

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    echo "df -h"  | sftp u377059@u377059.your-storagebox.de


### ~/bin/rclone-mount

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    remote=${1:-"hetzner"}
    if [ -d ~/$remote ]; then
        umount ~/${remote}
        rmdir ~/${remote}
        echo "Closed ~/${remote}"
    else
        mkdir -p ~/${remote}
        rclone mount $( [ "$2" != "rw" ] && echo "--read-only") ${remote}: ~/${remote} &> /dev/null &
        echo "Mounted ~/${remote}"
    fi


### ~/bin/gdrive-mount

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    rclone-mount gdrive "$1"


### ~/bin/hetzner-mount

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    rclone-mount hetzner "$1"


### ~/bin/syncrclone-htop

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    htop -F "syncrclone"


### ~/bin/syncrclone-once

    #!/usr/bin/env bash
    # Maintained in linux-config.org
    if ! network-online; then
        echo "offline"
        exit 1
    fi
    if pgrep -x "rclone" > /dev/null; then
        echo "syncrclone already running"
        exit 1
    else
        if [[ -z $SYNC_CRON ]]; then
            syncrclone | mail -s "syncrclone manual : $(date)" $USER
        else
            syncrclone
        fi
        exit 0
    fi


## cloud rsync between machines

    #Maintained in linux-config.org
    cloud/.syncrclone/
    Documents/.syncrclone/
    OpenAudible/aax/
    OpenAudible/books/


## Google Translate Helpers

    sudo apt install translate-shell


### ~/bin/google-trans

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    src=$1;shift;
    dst=$1;shift;
    txt=$@;
    trans -e google -s ${src} -t ${dst} -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$txt"


### ~/bin/google-trans-de-en

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    trans -e google -s de -t en -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$@"


### ~/bin/google-trans-en-de

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    trans -e google -s en -t de -show-original y -show-original-phonetics y -show-translation y -no-ansi -show-translation-phonetics n -show-prompt-message n -show-languages y -show-original-dictionary y -show-dictionary y -show-alternatives y "$@"


## Security/Locking/GPG


### ~/bin/gpg-cache

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

\#+end\_src


### ~/bin/pre-lock

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    [ -f "${HOME}"/.pre-lock ]  && . "${HOME}"/.pre-lock

1.  Sample .pre-lock

        #!/usr/bin/env bash
        xmg-neo-rgb-kbd-lights sleep


### ~/bin/post-lock

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    [ -f "${HOME}"/.post-lock  ]  && . "${HOME}"/.post-lock

1.  Sample .post-lock

        #!/usr/bin/env bash
        xmg-neo-rgb-kbd-lights wake


### ~/bin/pre-blank

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    command -v brightnessctl && brightnessctl -s
    [ -f ~/.pre-blank ]  && . ~/.pre-blank


### ~/bin/post-blank

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    [ -f ~/.post-blank ]  && . ~/.post-blank
    command -v brightnessctl && brightnessctl -r


# AIS

out of date

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    TMUX= tmux new  -A -s "AIS" AIScatcher

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    if ! pgrep AIS-catcher >/dev/null
    then
        echo "`date`: AIS-catcher down. Restarting." >> "${HOME}/.AISStatus"
        "${HOME}/bin/AIScatcher" &> /dev/null &
    fi

    #!/usr/bin/env bash
    #Maintained in linux-config.org
    "${HOME}/bin/AIS-catcher"  -d:0 -u 127.0.0.1 2345


# tailends


## ~/.bash\_profile

    
    [ -f "${HOME}/.bash_profile.local" ] && . "${HOME}/.bash_profile.local"
    [ -f "${HOME}/.cargo/env" ] && . "$HOME/.cargo/env"
    sway-autostart


## ~/.profile

    # fix for java apps in sway
    export _JAVA_AWT_WM_NONREPARENTING=1
    pgrep emacs > /dev/null || (emacs --daemon="general" > /dev/null 2>&1 & )
    [ -f "${HOME}/.profile.local" ] && . "${HOME}/.profile.local"


## sway config

    include /etc/sway/config.d/*
    include config-vars.d/*

