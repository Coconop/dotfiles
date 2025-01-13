########## Vanilla bashrc #####################################################

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='eza -alF'

# Default editor shall be [n]vim
export VISUAL=nvim
export EDITOR="$VISUAL"
export GIT_EDITOR=nvim

# Local folder for custom scripts/exe
mkdir -p ${HOME}/.local/bin
export PATH=${HOME}/.local/bin:${PATH}

# Personnal setup
if [ -d ~/.bash.d ]; then
    for file in ~/.bash.d/*.bash; do
        source "$file"
    done
fi

# Pro setup
if [ -d ~/.bash_local.d ]; then
    for file in ~/.bash_local.d/*.bash; do
        source "$file"
    done
fi

# Rust
. "$HOME/.cargo/env"
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library/

# Go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# GPG agent prompt in terminal
export GPG_TTY=$(tty)

# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Autocorrect bad commands
#eval "$(thefuck --alias)"
