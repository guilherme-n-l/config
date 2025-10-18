#!/bin/bash

ENVIRON=rust

echo "Welcome to $ENVIRON environment. Use \`help\` for a list of commands"
for cmd in rustc cargo rust-analyzer rustfmt rust-lldb; do
    $cmd --version
done

help() {
    declare -A functions=()

    echo "$ENVIRON environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}
