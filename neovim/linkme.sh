#!/bin/bash

# (c)  https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ../sourceme.sh

# In case it does not exists yet
mkdir -p ${HOME}/.config

safe_symlink ${SCRIPT_DIR}/nvim 	${HOME}/.config/nvim
