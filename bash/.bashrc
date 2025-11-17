# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

HISTIMEFORMAT="%F %T  "

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

# System syntax highlight on man pages
# --- Nord Theme for less ---
export LESS='-R'

# Nord palette (256-color approximations)
NORD0=$'\e[38;5;236m'   # dark polar night
NORD1=$'\e[38;5;237m'
NORD2=$'\e[38;5;238m'
NORD3=$'\e[38;5;239m'

NORD4=$'\e[38;5;252m'   # snow storm (light fg)
NORD5=$'\e[38;5;253m'
NORD6=$'\e[38;5;255m'

NORD7=$'\e[38;5;109m'   # frost colors
NORD8=$'\e[38;5;110m'
NORD9=$'\e[38;5;111m'
NORD10=$'\e[38;5;108m'

RESET=$'\e[0m'

# --- less capabilities ---
export LESS_TERMCAP_mb="$NORD8"                     # blinking → Nord blue
export LESS_TERMCAP_md="$NORD9"                     # bold → icy blue
export LESS_TERMCAP_me="$RESET"                     # end bold
export LESS_TERMCAP_us="$NORD10"                    # underline → Nord greenish
export LESS_TERMCAP_ue="$RESET"                     # end underline

# Standout (used by man-page section headers)
export LESS_TERMCAP_so=$'\e[48;5;237m\e[38;5;179m'  # dark bg + Nord yellow
export LESS_TERMCAP_se="$RESET"                     # end standout

# Optional: better man colors
export MANPAGER="less -R"
export MANROFFOPT="-c"

# Personnal setup
if [ -d ~/.my_bash ]; then
    for file in ~/.my_bash/*.bash; do
        source "$file"
    done
fi
if [ -d ~/.scripts ]; then
    export PATH="$PATH:$HOME/.scripts"
fi

# Pro setup
if [ -d ~/.pro_bash ]; then
    for file in ~/.pro_bash/*.bash; do
        source "$file"
    done
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
