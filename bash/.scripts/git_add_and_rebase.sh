#!/usr/bin/env bash

set -e

cmd=$(basename "$0")

show_help() {
    cat <<- HELP
    Usage: $cmd -b branch

    Add changes to staging area, commit and push them, then rebase current
    branch on the on given in argument.

    Script shall be executed in git repository.

    Ticket number is extracted from current branch name with format below:
    type/product-1234-long-description

    -> Will produce commit message:
    [product-1234] QuickFix

    Options:
        -h  Show this help message and exit
        -b  Name of the branch to rebase on

HELP
}

action() {
    set -x
    git add . && git commit -m "[$1] QuickFix" && git push && git rebase -i "$2" && git push --force-with-lease
    set +x
}

while getopts 'b:h' opt; do
    case "$opt" in
        b)
            branch="$OPTARG"
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

if [ -z "$branch" ]; then
    echo -e "\tERROR: Missing '-b [branch]'"
    exit 3
fi

ticket_nb="$(git rev-parse --abbrev-ref HEAD | cut -d '/' -f2 | cut -d '-' -f1,2)"

while true; do
    read -rp "$(echo -e "Push on $ticket_nb and rebase on $branch (y/n):")" response
    case "$response" in
        [Yy]* ) action "$ticket_nb" "$branch" && exit 0;;
        [Nn]* ) echo "Abort." && exit 4;;
        * ) echo -e "Please answer yes or no.";;
    esac
done
