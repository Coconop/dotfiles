#!/bin/bash

set -e

cmd=$(basename "$0")

show_help() {
    cat <<- HELP
    Usage: $cmd -r root_dir -f flags_file

    Generate a compile_commands.json at the root of a Makefile C project
    to allow clang LSP to index all found .c files.
    A 'compile_flags.txt' must be provided (warnings, includes, defines...).

    Options:
        -h  Show this help message and exit
        -r  Path to project root directory
        -f  Path to compile_flags.txt

HELP
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
            exit 2
            ;;
    esac
done
shift "$(("$OPTIND" -1))"

if [ -z "$root_dir" ]; then
    echo -e "\tERROR: Missing '-r [root_dir]'"
    exit 3
fi

if [ -z "$flag_file" ]; then
    echo -e "\tERROR Missing -f [flag_file]"
    exit 4
fi

flags=$(cat "$flag_file" | tr '\n' ' ')
json_db=$(echo "$root_dir"/compile_commands.json)

echo "[" > "$json_db"
first=1
for f in $(find . -name '*.c'); do
    [ $first -eq 0 ] && echo "," >> "$json_db"
    first=0
    echo "  {" >> "$json_db"
    echo "    \"directory\": \"$root_dir\"," >> "$json_db"
    echo "    \"command\": \"cc $flags -c $f\"," >> "$json_db"
    echo "    \"file\": \"$root_dir/$f\"" >> "$json_db"
    echo -n "  }" >> "$json_db"
done
echo "]" >> "$json_db"
