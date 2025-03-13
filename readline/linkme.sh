#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ../sourceme.sh
safe_symlink ${SCRIPT_DIR}/.inputrc 	            ${HOME}/.inputrc
