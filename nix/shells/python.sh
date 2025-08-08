#!/bin/bash

ENVIRON=python

echo "Welcome to $ENVIRON environment. Use \`help\` for a list of commands"

for cmd in python3 black pylsp pylint mypy; do
    $cmd --version | grep "$cmd"
done

isort --version

help() {
    declare -A functions=(
    )

    echo "$ENVIRON environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}
