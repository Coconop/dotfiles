#!/bin/bash

# TODO Check for minimal rust version required by tools

if command -v rustc >/dev/null 2>&1; then
    echo -e "Rust is installed"
    rustc --version
else
    echo -e "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# TODO just use LSP via Neovim + Mason 
if command -v rust-analyzer >/dev/null 2>&1; then
    echo -e "rust-analyzer is installed"
else
    echo -e "Installing Rust-analyzer"
    curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
    # It might fail here. Checkout https://askubuntu.com/a/1387286 and https://askubuntu.com/a/1501564 for WSL
    chmod +x ~/.local/bin/rust-analyzer
fi

# TODO Update PATH to give priority to cargo/bin
echo -e "Installing rust-written tools"
cargo install ripgrep
cargo install eza
cargo install --locked bat
cargo install --locked broot
cargo install fd-find
cargo install du-dust

ln -snfv $(which fdfind) ~/.local/bin/fd
# Need to be launched once to install shell scripts
broot

# Handy alias for bat
mkdir -p ~/.local/bin
ln -nfvs /usr/bin/batcat ~/.local/bin/bat
