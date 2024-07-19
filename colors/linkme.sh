#!/bin/bash

# (c)  https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -sfnv ${SCRIPT_DIR}/.dir_colors 	${HOME}/.dir_colors
