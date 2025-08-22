#!/bin/bash

ENVIRON=anime

echo "Welcome to $ENVIRON environment. Use \`help\` for a list of commands"

xdcc-cli --version

help() {
    declare -A functions=(
        ["get"]="Download files via xdcc -> get [ARGS...]"
    )

    echo "$ENVIRON environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}

get() {
    xdcc-cli "$*"
}
