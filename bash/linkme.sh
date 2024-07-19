#!/bin/bash

# (c)  https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -sfnv ${SCRIPT_DIR}/.bashrc 	            ${HOME}/.bashrc
ln -sfnv ${SCRIPT_DIR}/.bash_git 	        ${HOME}/.bash_git
ln -sfnv ${SCRIPT_DIR}/.bash_git_completion	${HOME}/.bash_git_completion
ln -sfnv ${SCRIPT_DIR}/.bash_prompt	        ${HOME}/.bash_prompt
