#!/bin/bash


ENVIRON=docker

if [ "$(uname)" == "Darwin" ];then
    if ! colima status > /dev/null 2>&1 ; then
        echo "Colima is down starting colima."
        colima start
    fi
    echo "Colima is up and running."
fi


echo "Welcome to $ENVIRON environment. Use \`help\` for a list of commands"


help() {
    declare -A functions=(
        ["colima.stop"]="Stops colima runtime."
        ["colima.start"]="Starts colima runtime."
        ["docker.runtmp"]="Run a temporary container with --rm and -it flags -> docker.runtmp [IMG] [SH]"
        ["docker.dev"]="Run a temporary Linux alpine VM"
    )

    echo "$ENVIRON environment available commands:"

    for cmd in "${!functions[@]}"; do
        echo -e "\t$cmd:\t${functions[$cmd]}"
    done
}

colima.stop() { 
    colima stop 
}

colima.start() { 
    colima start 
}

docker.runtmp() { 
    docker run --rm -it $@
}

docker.dev() {
    docker.runtmp ghcr.io/guilherme-n-l/base-dev:latest
}
