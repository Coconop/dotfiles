#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../sourceme.sh

safe_symlink ${SCRIPT_DIR}/.bashrc ${HOME}/.bashrc
safe_symlink ${SCRIPT_DIR}/.my_bash ${HOME}/.my_bash
safe_symlink ${SCRIPT_DIR}/.pro_bash ${HOME}/.pro_bash
touch ${HOME}/.pro_bash/hush.bash
