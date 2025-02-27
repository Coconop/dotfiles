#!/bin/bash

WORK_DIR=$(pwd)
cd ${HOME}/git/

git clone https://github.com/LuaLS/lua-language-server
cd ${HOME}/git/lua-language-server
# Requires Ninja, C++17, libstdc++ (libstdc++-static on Fedora)
./make.sh

cd ${WORK_DIR}

echo "Update PATH in bashrc:"
echo "export PATH=\${PATH}:${HOME}/git/lua-language-server/bin"
