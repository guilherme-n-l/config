#!/bin/bash

ENVIRON=perl

echo "Welcome to $ENVIRON environment. Use \`help\` for a list of commands"

perl --version | grep -v '^[[:space:]]*$' | head -n 1
for i in PLS Log::Log4perl Perl::Tidy; do
    version=$(cpan -D "$i" | grep "Installed" | awk '{print $NF}')
    echo "$i -- $version"
done

help() {
    declare -A functions=()

    echo "$ENVIRON environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}
