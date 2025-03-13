#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../sourceme.sh

safe_symlink ${SCRIPT_DIR}/.vimrc 	${HOME}/.vimrc
safe_symlink ${SCRIPT_DIR}/.vim 	${HOME}/.vim
