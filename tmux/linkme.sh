#!/bin/bash

if grep -qEi "(icrosoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
    IS_IN_WSL=1
else
    IS_IN_WSL=0
fi

# (c)  https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -sfnv ${SCRIPT_DIR}/.tmux.conf 	    ${HOME}/.tmux.conf

if [ $IS_IN_WSL -eq 1 ]; then
    ln -sfnv ${SCRIPT_DIR}/.tmux_wsl.conf 	${HOME}/.tmux_wsl.conf
else
    echo "${HOME}/.tmux_wsl.conf -> [EMPTY]"
    touch ${HOME}/.tmux_wsl.conf
fi
