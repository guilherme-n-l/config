#!/bin/bash

echo "Welcome to pandoc environment. Use \`help\` for a list of commands"

help() {
    declare -A functions=(
        ["topdf"]="Convert a file to pdf -> topdf [FILE] [ARGS...]"
    )

    echo "pandoc environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}

topdf() {
    pandoc "$1" -o "${1%.*}.pdf" "${@:2}"
}
