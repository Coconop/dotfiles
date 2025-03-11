#!/bin/bash

if command -v fzf >/dev/null 2>&1; then
    echo "FZF already installed:"
    fzf --version
    exit 0
fi

echo "Installing FZF..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
echo "FZF installed"
echo ""
echo "source ${HOME}/.bashrc"
