#!/bin/bash
# TODO Help flag to pass Project ROOT dir and path to compile_flags.txt
project_dir="$1"
flags=$(cat $2 | tr '\n' ' ')

echo "[" > compile_commands.json
first=1
for f in $(find . -name '*.c'); do
    [ $first -eq 0 ] && echo "," >> compile_commands.json
    first=0
    echo "  {" >> compile_commands.json
    echo "    \"directory\": \"$project_dir\"," >> compile_commands.json
    echo "    \"command\": \"cc $flags -c $f\"," >> compile_commands.json
    echo "    \"file\": \"$project_dir/$f\"" >> compile_commands.json
    echo -n "  }" >> compile_commands.json
done
echo "]" >> compile_commands.json

