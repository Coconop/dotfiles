#!/bin/bash

echo -e "Setting up global git config"
git config --global core.editor "nvim"
git config --global core.autocrlf input
git config --global merge.tool "nvimdiff"
git config --global merge.conflictStyle "merge"

echo -e "Setting up local git config"
# Hey that's me :)
git config --local user.name "Coconop"
# I'm anonymous!
git config --local user.email "9349239+Coconop@users.noreply.github.com"
# Annoying, nothing sensitive here
git config --local commit.gpgsign false
# We don't care about line endings
git config --local core.safecrlf false
