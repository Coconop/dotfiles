#!/bin/bash
# Extract all directories containing included headers

# Find all C/C++ source files
src_files=$(find . -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" \))

tmp_headers=$(mktemp)

# Extract header names from source files
for file in $src_files; do
    grep -E '^[[:space:]]*#include[[:space:]]*["<][^">]+[">]' "$file" 2>/dev/null \
    | sed -E 's/.*#include[[:space:]]*["<]([^">]+)[">].*/\1/'
done | sort -u > "$tmp_headers"

# Find directories containing the headers
while read -r hdr; do
    # Search project tree
    found=$(find . -type f -name "$(basename "$hdr")" 2>/dev/null)
    for f in $found; do
        dirname "$f"
    done
done < "$tmp_headers" | sort -u

rm -f "$tmp_headers"

