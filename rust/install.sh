#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../sourceme.sh

# TODO Check for minimal rust version required by tools

if command -v rustc >/dev/null 2>&1; then
    echo -e "Rust is installed"
    rustc --version
fi

if ask_for_confirmation "(Re)install last version of Rust ?"; then
    echo -e "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if command -v rust-analyzer >/dev/null 2>&1; then
    echo -e "rust-analyzer is installed"
fi

if ask_for_confirmation "(Re)install last version of Rust-Analyzer ?"; then
    echo -e "Installing Rust-analyzer"
    curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
    # Might need a tac-tac: https://stackoverflow.com/a/28879552/3194340
    # It might fail here. Checkout https://askubuntu.com/a/1387286 and https://askubuntu.com/a/1501564 for WSL
    chmod +x ~/.local/bin/rust-analyzer
fi

if ask_for_confirmation "Painfully slowly Install blazlingly fast tools ?"; then
    echo -e "${Yel}If you have system-version of these tools, ensure carg/bin has priority in PATH ${None}"

    # Better grep
    echo -e "Installing ripgrep"
    cargo install ripgrep

    # Better ls
    echo -e "Installing eza"
    cargo install eza

    # Better cat
    echo -e "Installing bat"
    cargo install --locked bat
    mkdir -p ~/.local/bin
    safe_symlink /usr/bin/batcat ~/.local/bin/bat

    # Better find
    echo -e "Installing fd"
    cargo install fd-find
    safe_symlink "$(which fdfind)" ~/.local/bin/fd
    echo -e "Done."
fi
