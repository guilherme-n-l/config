#!/bin/bash

ENVIRON=C
CC=$([[ "$(uname)" == "Darwin" ]] && echo "clang" || echo "gcc")

source "${CONFIG_PATH}/nix/shells/utils.sh"

echo "Welcome to $ENVIRON environment. Use \`help\` for a list of commands"

gcc --version | head -n 1
clangd --version | head -n 1

help() {
    declare -A functions=(
        ["get_make"]="Create a simple Makefile to compile \$1 -> get_make [ARGS...]"
        ["init"]="Create a C project with name \$1 -> init [ARGS...]"
    )

    echo "$ENVIRON environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}

_get_filename() {
    local filename="${1:-main}"
    local filename="${filename%.c}"
    echo $filename
}

_create_file() {
    local filename="$1"
    if [[ -f "$filename" ]]; then
        _confirm "Replacing $filename" || return 0
    fi
    echo "$2" > "$filename"
    sed -i 's/^\( \+\)/\t/' "$filename"
    
}

get_make() {
    local filename="$(_get_filename $1)"
    local makefile="Makefile"
    _create_file "$makefile" "$(cat <<-EOF
# GENERATED MAKEFILE FOR ${filename}
CC=${CC}
CFLAGS=
# CFLAGS=-Wall -g
LDFLAGS=

SRCS=\$(wildcard *.c)
TARGET=${filename}

all: \$(TARGET)

\$(TARGET): \$(SRCS)
    \$(CC) \$(CFLAGS) \$(LDFLAGS) -o \$@ \$^

clean:
    rm -f \$(TARGET)

help:
    @echo "Usage: make [target]"
    @echo "Targets available:"
    @echo "  clean  - Remove generated files"
    @echo "  help   - Print this help message"

.PHONY: help clean
EOF
)"
}

init() {
    local filename="$(_get_filename $1)"
    get_make $filename
    _create_file "${filename}.c" "$(cat <<-EOF
int main() {
    return 0;
}
EOF
)"
}
