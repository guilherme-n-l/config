#################
#   Behavior    #
#################
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY


#################
# Customization #
#################
autoload -U colors && colors
PS1="%{$fg[yellow]%}%~%{$reset_color%} %{$fg[cyan]%}%% %{$reset_color%}"


#################
#   VARIABLES   #
#################

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HYPHEN_INSENSITIVE='true'

declare -A zsh_aliases=(
['sd']='sudo shutdown -h now'
['rb']='sudo shutdown -r now'
['fzfd']='fd --hidden --type d | fzf'
['lg']='lazygit'
['gs']='git status'
['gc']='git commit'
['gcl']='git clone'
['gcfg']='git config'
['gco']='git checkout'
['gf']='git fetch origin'
['gp']='git pull'
['gp']='git push'
['gl']="git log --graph --abbrev-commit --decorate"
['gwa']='git worktree add'
['gwr']='git worktree remove'
['gwl']='git worktree list'
['bu']='blueutil'
['install']='brew install'
['reinstall']='brew reinstall'
['search']='brew search'
['remove']='brew remove'
['tm']='tmux'
['tmks']='tmux kill-server'
['tmkw']='tmux kill-window'
['..']='cd ..'
['...']='cd ../..'
)

declare -A zsh_binds=(
['^[[1;3C']='forward-word'
['^[[1;3D']='backward-word'
['^[[1;5C']='forward-word'
['^[[1;5D']='backward-word'
['^[^?']='backward-kill-word'
['^H']='backward-kill-word'
['^R']='history-incremental-search-backward'
['^F']='fcd_widget'
)

path_list=(
"$HOME/.go/bin"
"$HOME/.bun/bin"
)

path="${(j.:.)path_list}:$PATH"
declare -A zsh_exports=(
['EDITOR']='nvim'
['DYLD_LIBRARY_PATH']='/usr/local/lib'
['PATH']=$path
)

zsh_sources=(
'/opt/homebrew/Cellar/zsh-syntax-highlighting/0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
)


#################
#   Bindings    #
#################

function yz() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$pwd" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function fcd() {
    local ignored=(
        .cache
        .colima
        .docker
        .git
        Library
        )

    local args=""
    for d in "${ignored[@]}"; do
        args+=" -E \"$d\""
    done

    eval "cd \$(fd --hidden $args --type d | fzf || pwd)"
}

function nh() {
    nohup $@ &> /dev/null &
}

function zread() {
    nh zathura $@
}

function fcd_widget() {
  zle -I
  fcd
  # zle reset-prompt
}

zle -N fcd_widget

for k in ${(k)zsh_aliases}; alias "$k"="${zsh_aliases[$k]}";
for k in ${(k)zsh_binds}; bindkey "$k" "${zsh_binds[$k]}";
for k in ${(k)zsh_exports}; export "$k"="${zsh_exports[$k]}";
for i in $zsh_sources; source $i;
eval "$(/opt/homebrew/bin/brew shellenv)"
