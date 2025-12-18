{
  install_config = ''
    if [ -z "$CONFIG_PATH" ]; then
        echo "unable to locate config path" >&2
        echo "configuration will not be updated" >&2
        return 1
    fi
    stow -d "$CONFIG_PATH/dotfiles" -t "$HOME" $(basename -a "$CONFIG_PATH/dotfiles/"*)
  '';
  # Nix
  rebuild = ''
    local cmd=$([ "$(uname)" = "Darwin" ] && echo darwin-rebuild || echo nixos-rebuild)
    flake="$1"
    shift 
    install_config
    sudo $cmd switch --flake $CONFIG_PATH/#$flake $@
  '';

  dev = ''
    shellFilePath="$CONFIG_PATH/nix/shells/$1.nix"
    if [ -f "$shellFilePath" ]; then
        nix-shell $shellFilePath
    else
    nix develop $1 || {
            availableShells=$(find $CONFIG_PATH/nix/shells -type f -name "*.nix" -exec basename {} .nix \; | awk '{print "\t" $0}')
            echo -e "Available shells:\n$availableShells"
        }
    fi
  '';

  # Yazi
  yz = ''
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$pwd" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  '';

  # Motions
  fcd = ''
    local ignored=( .cache .colima .docker .git Library )
    local args=""
    for d in $ignored; do
        args+=" -E \"$d\""
    done
    eval "cd \$(fd --hidden $args --type d | fzf || pwd)"
  '';
  fcd_widget = ''
    zle -I
    fcd
  '';

  # Misc.
  "_update_git_branch" = ''
    local branch=$(git branch 2> /dev/null | grep \* | colrm 1 2)
    GIT_BRANCH=$([ ! -z $branch ] && echo "($branch) " || echo "")
  '';
  "_update_prompt" = ''PS1="%F{blue}%~ %f''${GIT_BRANCH}%(?.%F{green}.%F{red})%#%f "'';
  nh = ''
    nohup $@ &> /dev/null &
  '';
  zread = ''
    nh zathura $@
  '';
}
