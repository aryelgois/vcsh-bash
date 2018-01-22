# Executed by bash(1) for non-login shells

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize

# The `**` pattern in a glob should match any number of directories
shopt -s globstar

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Append to the history file, don't overwrite it
shopt -s histappend

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# I want all my history
HISTSIZE='INFINITE'
HISTFILESIZE='AND BEYONDE'

# History time format
HISTTIMEFORMAT='%F %T: '

# Read history
history -r

# Add history header
history -s ':'
history -s ": $(echo -n $'\e[1m')$USER@${HOST:-$HOSTNAME}$(echo -n $'\e[0m')"
history -s ':'

# Display my username and hostname in the xterm titlebar
if [ "$TERM" = "xterm" ]; then
    echo -ne "\033]0;$USER@${HOST:-$HOSTNAME}\007"
fi

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Use a colored prompt if the terminal has the capability
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

# Git prompt
if set | grep __git_ps1 > /dev/null; then
    GIT_PS1_SHOWDIRTYSTATE=1     # unstaged (*), staged (+)
    GIT_PS1_SHOWSTASHSTATE=1     # stashed ($)
    GIT_PS1_SHOWUNTRACKEDFILES=1 # untracked files (%)
    GIT_PS1_SHOWUPSTREAM="auto"  # behind (<), ahead (>), diverged (<>), no difference (=) between HEAD and its upstream
    git_prompt=yes
fi

# Update prompt
#   $1 use colors    (yes|*)
#   $2 use __git_ps1 (yes|*)
update_PS1 () {
    RET=$?; RET=$([ $RET -gt 0 ] && echo " ($RET)")
    [ "$2" = yes ] && GIT_PROMPT="$(__git_ps1 " [%s]")"
    SEP=$([ -n "$RET" -o -n "$GIT_PROMPT" ] && echo ' ')
    if [ "$1" = yes ]; then
        PS1='${debian_chroot:+[$debian_chroot]}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$GIT_PROMPT${RET:+\[\033[01;31m\]$RET\[\033[00m\]}$SEP\$ '
    else
        PS1='${debian_chroot:+[$debian_chroot]}\u@\h:\w$GIT_PROMPT$RET$SEP\$ '
    fi
}
PROMPT_COMMAND="update_PS1 '$color_prompt' '$git_prompt'"
unset color_prompt git_prompt

# An excellent pager is of the utmost importance to the Unix experience
export LESS="-i -j.49 -M -R -z-2"
export PAGER=less

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of ls(1) and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some more ls(1) aliases
alias la="ls -AvCF"
alias lf="ls -vCF"
alias ll="ls -lvF"
alias lla="ls -alvF"
alias ltr="ls -ltr"
alias ltra="ls -ltra"

# Colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Colored diff
if [ -x /usr/bin/colordiff ]; then DIFF=colordiff; else DIFF=diff; fi

# diff(1) and wdiff(1) shortcuts
d () {
    if [ -t 1 ]; then
        $DIFF -ur "$@" 2>&1 | less
    else
        $DIFF -ur "$@"
    fi
}
wd () {
    diff -u "$@" |
    wdiff -d -n -w $'\033[31m' -x $'\033[0m' \
                -y $'\033[32m' -z $'\033[0m'
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Prevent Ubuntu from doing a painstaking search of its package database
# every time I misspell a command
if [ -n "$BASH" ]; then
    unset -f command_not_found_handle
fi

# Load any site-specific commands that I have defined
if [ -f "$HOME/.localrc" ]; then
    . "$HOME/.localrc"
fi
