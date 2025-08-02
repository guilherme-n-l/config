#!/bin/bash

ENVIRON=rust

echo "Welcome to $ENVIRON environment. Use \`help\` for a list of commands"
rustc --version
rust-analyzer --version
cargo --version

help() {
    declare -A functions=()

    echo "$ENVIRON environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}
