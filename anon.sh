#!/bin/sh

# New author and committer details
NEW_NAME="Coconop"
NEW_EMAIL="9349239+Coconop@users.noreply.github.com"

# Rewrite all commits in all branches
git filter-branch -f --env-filter "
    export GIT_AUTHOR_NAME='$NEW_NAME'
    export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
    export GIT_COMMITTER_NAME='$NEW_NAME'
    export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
" --tag-name-filter cat -- --all

# Cleanup: Remove old refs and expire reflogs
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive
