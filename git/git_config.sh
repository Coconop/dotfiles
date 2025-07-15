#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}"/../sourceme.sh

safe_symlink ${SCRIPT_DIR}/.gitignore_global "${HOME}"/.gitignore_global

echo -e "Setting up global git config"
git config --global core.editor "nvim"
git config --global core.autocrlf input
git config --global merge.tool "nvimdiff"
git config --global merge.conflictStyle "merge"
git config --global core.excludesFile "${HOME}/".gitignore_global

echo -e "Setting up local git config"
# Hey that's me :)
git config --local user.name "Coconop"
# I'm anonymous!
git config --local user.email "9349239+Coconop@users.noreply.github.com"
# Annoying, nothing sensitive here
git config --local commit.gpgsign false
# We don't care about line endings
git config --local core.safecrlf false

 git congif --local credential.username "coconop"
# git congif --local credential.helper "!func(){ echo "username=coconop"; echo "password=$(pass git/github/coconop)"; }; func"
