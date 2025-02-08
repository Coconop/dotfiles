#!/bin/bash

FONT_0xPROTO="0xProto"
#FONT_JETBRAINS="JetBrainsMono"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Checkout https://github.com/ryanoasis/nerd-fonts/releases for more Nerd Fonts"

if [ -d ${HOME}/.fonts/${FONT_0xPROTO} ]; then
    echo "${FONT_0xPROTO} already installed"
else
    mkdir -p ${HOME}/.fonts/${FONT_0xPROTO}
    tar -xvf ${SCRIPT_DIR}/${FONT_0xPROTO}.tar.xz -C ${HOME}/.fonts/${FONT_0xPROTO}
    echo "${FONT_0xPROTO} installed"
    echo "Refreshing cache (sudo)..."
    sudo fc-cache -fv
fi
