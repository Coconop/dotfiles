#!/bin/bash

echo -e "Setting up global git config"
git config --global core.editor "nvim"
git config --global core.autocrlf input
git config --global merge.tool "nvimdiff"
git config --global merge.conflictStyle "merge"

echo -e "Setting up localgit config"
git config --local user.name "Coconop"
git config --local user.email "Coconop_has_no_m@il.com"
git config --local commit.gpgsign false
