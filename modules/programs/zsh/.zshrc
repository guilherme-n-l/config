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

# Rebuild the full nix-darwin/nixos system configuration.
# Usage: rebuild [hostname] [extra flags]
# Defaults to $NIXHOST or the current hostname.
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

# Build and add a flake package to the user profile.
# Useful for iterating on a package (e.g. neovim) without a full system rebuild.
# Usage: use <package>  (e.g. use neovim)
use() {
    nix profile add "${CONFIG}/#$1"
}

# Enter a nix dev shell. Looks for a .nix file in $CONFIG/nix/shells first,
# then falls back to `nix develop`. Lists available shells on failure.
# Usage: dev <shell>
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

# Open yazi and cd into the directory yazi exits to.
# Usage: yz [yazi args]
yz() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$pwd" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Fuzzy cd using fd + fzf, ignoring common noisy directories.
# Usage: fcd
fcd() {
    local ignored=( .cache .colima .docker .git Library )
    local args=""
    for d in $ignored; do
        args+=" -E \"$d\""
    done
    eval "cd \$(fd --hidden $args --type d | fzf || pwd)"
}

# ZLE widget wrapper for fcd (bound to ^F).
fcd_widget() {
    zle -I
    fcd
}

# Updates $GIT_BRANCH for use in the prompt. Runs on chpwd and precmd.
_update_git_branch() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -n "$branch" && "$branch" != "HEAD" ]] \
        && GIT_BRANCH="($branch) " \
        || GIT_BRANCH=""
}

# Rebuilds PS1 with current path, git branch, and last exit code color.
_update_prompt() {
    PS1="%F{blue}%~ %f${GIT_BRANCH}%(?.%F{green}.%F{red})%#%f "
}

# Run a command detached from the terminal (nohup, silent).
# Usage: nh <command> [args]
nh() {
    nohup $@ &> /dev/null &
}

# Open a PDF with zathura detached from the terminal.
# Usage: zread <file>
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
