#!/bin/bash

# (c)  https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -sfnv ${SCRIPT_DIR}/.vimrc 	${HOME}/.vimrc
ln -sfnv ${SCRIPT_DIR}/.vim 	${HOME}/.vim
