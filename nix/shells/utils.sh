#!/bin/bash

_confirm() {
    echo -n "$1 [y/N]: " >&2
    read response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}
