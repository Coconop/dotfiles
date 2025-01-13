#!/bin/bash

# (c)  https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -sfnv ${SCRIPT_DIR}/.bashrc 	            ${HOME}/.bashrc
ln -sfnv ${SCRIPT_DIR}/.bash.d 	            ${HOME}/.bash.d
ln -sfnv ${SCRIPT_DIR}/.bash.local          ${HOME}/.bash.local
