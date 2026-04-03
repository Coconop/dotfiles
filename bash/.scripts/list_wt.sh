#!/bin/bash

# Get a tree view of a directory containing git repositories

echo "$1/"
for d in "$1"/*/; do
  name=$(basename "$d")
  branch=$(git -C "$d" branch --show-current 2>/dev/null)
  remote=$(git -C "$d" rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "∅")
  printf "├── %-25s [%s] → %s\n" "$name" "$branch" "$remote"
done
