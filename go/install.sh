#!/bin/bash

if command -v go >/dev/null 2>&1; then
    echo -e "Go is installed:"
    go version
else
    echo -e "Installing Go..."
    # TODO retrieve last version
    wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
    rm go1.22.5.linux-amd64.tar.gz
    export PATH=$PATH:/usr/local/go/bin
fi

echo -e "Installing go-written tools"
go install github.com/jesseduffield/lazygit@latest
