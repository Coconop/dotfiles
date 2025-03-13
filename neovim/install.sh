#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../sourceme.sh

if ask_for_confirmation "Do you need to install prerequisites ?"; then
    echo -e "Ubuntu/Debian:"
    echo -e "sudo apt-get install ninja-build gettext cmake curl build-essential"
    echo -e ""
    echo -e "RHEL/Fedora:"
    echo -e "sudo dnf config-manager --set-enabled crb"
    echo -e "sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra"
    echo -e ""
    echo -e "Or, to build dependencies from sources:"
    echo -e "sudo dnf groupinstall "Development Tools""

    exit 1
fi

if command -v nvim >/dev/null 2>&1; then
    echo -e "neovim is installed:"
    nvim --version
else
    echo -e "Installing Neovim..."
    #https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source
    echo -e "Neovim will be launched interactively for 1st installation"
    # TODO check for neovim git repo, cd to it and:
    # sudo cmake --build build/ --target uninstall
    WORK_DIR=$(pwd)
    mkdir -p "$HOME/git"
    cd "$HOME/git"
    git clone https://github.com/neovim/neovim.git || true
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd "$WORK_DIR"
    source "${HOME}/.bashrc"
    # Do checkhealth & PlugInstall
    /usr/local/bin/nvim
fi
