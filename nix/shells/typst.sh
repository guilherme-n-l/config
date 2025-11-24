#!/bin/bash

ENVIRON=typst

echo "Welcome to $ENVIRON environment. Use \`help\` for a list of commands"

for cmd in typst websocat; do
    $cmd --version
done
echo "typstfmt: $(typstfmt --version | awk '{print $2}')"

help() {
    declare -A functions=()

    echo "$ENVIRON environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}
