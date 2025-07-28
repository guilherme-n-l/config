FROM alpine:latest

ARG CONFIG_REPO="https://github.com/guilherme-n-l/config"

ENV HOME="/root"
ENV CONFIG_REPO_GIT="${CONFIG_REPO}.git"
ENV CONFIG_PATH="$HOME/config"
ENV CONFIG_PATH="$HOME/config"

RUN apk update \
    && apk add --no-cache build-base git stow neovim yazi \
    && git clone $CONFIG_REPO_GIT $CONFIG_PATH \
    && stow -d "$CONFIG_PATH/dotfiles" -t "$HOME" $(basename -a "$CONFIG_PATH/dotfiles/"*)

LABEL org.opencontainers.image.source=${CONFIG_REPO}
