#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/../sourceme.sh"

# TODO Check for minimal rust version required by tools

if command -v rustc >/dev/null 2>&1; then
    echo -e "Rust is installed"
    rustc --version
else
    echo -e "rustc not found: install Rust toolchain"
    exit 1
fi

if ask_for_confirmation "Cancel current script to manually install optionnal extensions ?"; then
    echo -e "Use your package manager to install:"
    echo -e "ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick"
    echo -e ""
    exit 1
fi

if ask_for_confirmation "Install ueberzugpp for img support ?"; then
    # Must be installed in order to build.
    # cmake ≥ 3.22
    # libvips
    # libsixel
    # chafa ≥ 1.6
    # openssl
    # tbb
    # On Ubuntu: apt-get install libssl-dev libvips-dev libsixel-dev libchafa-dev libtbb-dev
    #
    # Required for building, if they are not installed, they will be downloaded and included in the binary.
    # nlohmann-json
    # cli11
    # spdlog
    # fmt
    # range-v3

    workdir=$(pwd)
    cd ${HOME}/git/
    git clone https://github.com/jstkdng/ueberzugpp.git
    cd ueberzugpp
    mkdir build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release ..
    cmake --build .
    cmake --install build
    cd $workdir
fi

cargo install --locked yazi-fm yazi-cli

if [[ $? -ne 0 ]]
then
    echo -e "please check if make and gcc is installed on your system"
fi

echo -e "Yazi installed"
echo -e "Consider adding this to your bashrc:"
cat <<- "EOF"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
EOF

