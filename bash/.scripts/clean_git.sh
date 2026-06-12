#!/usr/bin/env bash
set -euo pipefail

# Detect whether the default branch is 'main' or 'master'
if git show-ref --verify --quiet refs/heads/main; then
    default_branch="main"
elif git show-ref --verify --quiet refs/heads/master; then
    default_branch="master"
else
    echo "Error: neither 'main' nor 'master' branch found in this repository." >&2
    exit 1
fi

echo "Default branch detected: $default_branch"

# Delete local branches already merged into the default branch
merged=$(git branch --merged="$default_branch" | grep -v "^\*\?[[:space:]]*$default_branch$")

if [ -z "$merged" ]; then
    echo "No merged branches to delete."
else
    echo "Deleting merged branches:"
    echo "$merged"
    git branch -d $merged
fi

# Prune remote-tracking refs that no longer exist on the remote
echo "Pruning stale remote-tracking branches..."
git fetch --prune

echo "Done."
