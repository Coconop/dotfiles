#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../sourceme.sh

# In case it does not exists yet
mkdir -p ${HOME}/.config

safe_symlink ${SCRIPT_DIR}/nvim 	${HOME}/.config/nvim
