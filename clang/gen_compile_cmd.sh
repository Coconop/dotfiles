#!/bin/bash
# This script shall be placed at the root of project
# Along with `compile_flags.txt`
project_dir="$(pwd)"
flags=$(cat compile_flags.txt | tr '\n' ' ')

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

