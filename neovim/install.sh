#!/bin/bash


if command -v nvim >/dev/null 2>&1; then
    echo -e "neovim is installed:"
    nvim --version
else
    echo -e "Installing Neovim..."
#https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source
    echo -e "Neovim will be launched interactively for 1st installation"
    # TODO check for neovim git repo, cd to it and:
    # sudo cmake --build build/ --target uninstall
    WORK_DIR=`pwd`
    mkdir -p $HOME/git
    cd $HOME/git
    git clone https://github.com/neovim/neovim.git || true
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd $WORK_DIR
    source ${HOME}/.bashrc
    # Do checkhealth & PlugInstall
    /usr/local/bin/nvim
fi
