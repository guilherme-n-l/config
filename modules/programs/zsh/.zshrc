# Environment Variables
export CONFIG="$HOME/config"
export EDITOR="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# PATH
export PATH="$HOME/.npm/bin:$HOME/.go/bin:$HOME/.bun/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# History
export HISTDUP="erase"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Prompt
setopt prompt_subst

# Functions
rebuild() {
    local cmd=$([ "$(uname)" = "Darwin" ] && echo darwin-rebuild || echo nixos-rebuild)
    local flake
    if [[ -n "$1" ]]; then
        flake="$1"
        shift
    else
        flake="${NIXHOST:-$(hostname -s)}"
    fi
    sudo $cmd switch --flake "${CONFIG}/#${flake}" $@
}

dev() {
    local shellFilePath="${CONFIG}/nix/shells/$1.nix"
    if [ -f "$shellFilePath" ]; then
        nix-shell $shellFilePath
    else
        nix develop $1 || {
            local availableShells=$(find $CONFIG/nix/shells -type f -name "*.nix" -exec basename {} .nix \; | awk '{print "\t" $0}')
            echo -e "Available shells:\n$availableShells"
        }
    fi
}

yz() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$pwd" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

fcd() {
    local ignored=( .cache .colima .docker .git Library )
    local args=""
    for d in $ignored; do
        args+=" -E \"$d\""
    done
    eval "cd \$(fd --hidden $args --type d | fzf || pwd)"
}

fcd_widget() {
    zle -I
    fcd
}

_update_git_branch() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -n "$branch" && "$branch" != "HEAD" ]] \
        && GIT_BRANCH="($branch) " \
        || GIT_BRANCH=""
}

_update_prompt() {
    PS1="%F{blue}%~ %f${GIT_BRANCH}%(?.%F{green}.%F{red})%#%f "
}

nh() {
    nohup $@ &> /dev/null &
}

zread() {
    nh zathura $@
}

# Hooks
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _update_git_branch
add-zsh-hook precmd _update_git_branch
add-zsh-hook precmd _update_prompt

# Aliases
alias ngc="sudo nix-collect-garbage -d"
alias sd="sudo shutdown -h now"
alias rb="sudo shutdown -r now"
alias fzfd="fd --hidden --type d | fzf"
alias lg="lazygit"
alias gs="git status"
alias gc="git commit"
alias gcl="git clone"
alias gcfg="git config"
alias gco="git checkout"
alias gf="git fetch origin"
alias gp="git pull"
alias gP="git push"
alias gl="git log --graph --abbrev-commit --decorate"
alias gwa="git worktree add"
alias gwr="git worktree remove"
alias gwl="git worktree list"

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ZLE Widgets
zle -N fcd_widget

# Bindkeys
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[^?" backward-kill-word
bindkey "^H" backward-kill-word
bindkey "^R" history-incremental-search-backward
bindkey "^F" fcd_widget
bindkey "^P" history-search-backward
bindkey "^N" history-search-forward

# Sources
source "$(sed 's/\(.*\)\/bin.*/\1/' <(readlink -f $(which fzf | head -n 1)))/share/fzf/completion.zsh"

# Evals
eval "$(zoxide init $(basename $SHELL))"
