#!/bin/bash

set -e

show_help() {
    cat << EOF
    Usage: $0 -r root_dir -f flags_file

    Generate a compile_commands.json at the root of a Makefile C project
    to allow clang LSP to index all found .c files.
    A `compile_flags.txt` must be provided (warnings, includes, defines...).

    Options:
        -h  Show this help message and exit
        -r  Path to project root directory
        -f  Path to compile_flags.txt
    EOF
}

while getopts 'r:f:h' opt; do
    case "$opt" in
        r)
            root_dir="$OPTARG"
            ;;
        f)
            flag_file="$OPTARG"
            ;;
        h)
            show_help
            exit 0
            ;;
        :)
            echo -e "Option requires an argument"
            show_help
            exit 1
            ;;
        ?)
            echo -e "Invalid option"
            show_help
            exit 0
            ;;
    esac
done
shift "$(("$OPTIND" -1))"

flags=$(cat "$flag_file" | tr '\n' ' ')
json_db=$(echo "$root_dir"/compile_commands.json)

echo "[" > "$json_db"
first=1
for f in $(find . -name '*.c'); do
    [ $first -eq 0 ] && echo "," >> "$json_db"
    first=0
    echo "  {" >> "$json_db"
    echo "    \"directory\": \"$project_dir\"," >> "$json_db"
    echo "    \"command\": \"cc $flags -c $f\"," >> "$json_db"
    echo "    \"file\": \"$project_dir/$f\"" >> "$json_db"
    echo -n "  }" >> "$json_db"
done
echo "]" >> "$json_db"
