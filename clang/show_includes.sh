#!/bin/bash
# Extract all directories containing included headers

# TODO
progress-bar() {
	local current=$1
	local len=$2

	local bar_char='|'
	local empty_char=' '
	local length=50
	local perc_done=$((current * 100 / len))
	local num_bars=$((perc_done * length / 100))

	local i
	local s='['
	for ((i = 0; i < num_bars; i++)); do
		s+=$bar_char
	done
	for ((i = num_bars; i < length; i++)); do
		s+=$empty_char
	done
	s+=']'

	echo -ne "$s $current/$len ($perc_done%)\r"
}

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

