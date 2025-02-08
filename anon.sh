#!/bin/sh

git filter-branch -f --env-filter "
export GIT_AUTHOR_NAME="Coconop"
export GIT_AUTHOR_EMAIL="9349239+Coconop@users.noreply.github.com"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
" --tag-name-filter cat -- --all

# Cleanup: Remove old refs and expire reflogs
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive
