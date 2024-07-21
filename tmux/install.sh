#!/bin/bash


if command -v tmux >/dev/null 2>&1; then
    echo -e "tmux is installed"
    tmux -V
else
    echo -e "Installing tmux..."
    # https://github.com/tmux/tmux/wiki/Installing#from-version-control
    echo -e "${Yel}WARNING packet are probably missing. Better install manually${None}"
    WORK_DIR=`pwd`
    mkdir -p ${HOME}/git
    cd ${HOME}/git
    git clone https://github.com/tmux/tmux.git || true
    cd tmux
    git checkout 3.4
    sh autogen.sh
    ./configure
    make && sudo make install
    source ${HOME}/.bashrc

    echo -e "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true

    cd $WORK_DIR
fi
