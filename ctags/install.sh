#!/bin/bash

if [ -d "${HOME}ctags" ]; then
    echo "Ctags already installed"
    exit 0
fi

WORK_DIR=$(pwd)
cd ${HOME}

git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
# use --prefix=/where/you/want to override installation directory, defaults to /usr/local
./configure  
make
# may require extra privileges depending on where to install
make install

cd ${WORK_DIR}
echo "Ctags installed"
