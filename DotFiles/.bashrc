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

function parse_git_branch_and_add_brackets {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\[\1\]/'
}

# export IP=`myip`
# export PS1='($IP) [\!]\[\033[00;32m\]\u\[\033[01m\]@\[\033[00;36m\]\h\[\033[01m\]:\[\033[00;35m\]\w\[\033[00m\]\[\033[01;33m\]`git branch 2>/dev/null|cut -f2 -d\* -s`\[\033[00m\]\$ '
# export PS1='\[\e[0;33m\]\u\[\e[m\] \[\e[0;31m\]($IP)\[\e[m\]@\[\e[0;34m\][\W]\[\e[m\]`git branch 2>/dev/null|cut -f2 -d\* -s`$ '
export PS1="\\w:\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ "

unset color_prompt force_color_prompt

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

stty -ixon

GPG_TTY=$(tty)
export GPG_TTY

if [ -f "$HOME/bin/thirdpaty/bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/bin/thirdparty/bash-git-prompt/gitprompt.sh
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
