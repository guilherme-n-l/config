{ pkgs, ... }:

let
variables = import ./variables.nix;

aliases = {
# Nix
    ngc = "sudo nix-collect-garbage -d";

# System Shutdown/Reboot
    sd = "sudo shutdown -h now";
    rb = "sudo shutdown -r now";

# Fzf Directory Search
    fzfd = "fd --hidden --type d | fzf";

# Lazygit
    lg = "lazygit";

# Git
    gs = "git status";
    gc = "git commit";
    gcl = "git clone";
    gcfg = "git config";
    gco = "git checkout";
    gf = "git fetch origin";
    gp = "git pull";
    gP = "git push";
    gl = "git log --graph --abbrev-commit --decorate";
    gwa = "git worktree add";
    gwr = "git worktree remove";
    gwl = "git worktree list";
};

functions = {
# Nix
    rebuild = ''{
        cmd=$([ "$(uname)" = "Darwin" ] && echo darwin-rebuild || echo nixos-rebuild)
        stow -d "$CONFIG_PATH/dotfiles" -t "$HOME" $(basename -a "$CONFIG_PATH/dotfiles/"*) ;\
            sudo $cmd switch --flake $CONFIG_PATH/#$1
    }'';

# Yazi
    yz =  ''{
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$pwd" ]; then
                cd -- "$cwd"
                    fi
                    rm -f -- "$tmp"
    }'';

# Motions
    fcd = ''{
        local ignored=(
                .cache
                .colima
                .docker
                .git
                Library
                )

            local args=""
            for d in $ignored; do
                args+=" -E \"$d\""
                    done

                    eval "cd \$(fd --hidden $args --type d | fzf || pwd)"
    }'';
    fcd_widget = ''{
        zle -I
            fcd
    }
    zle -N fcd_widget'';

# Misc.
    git_branch = ''{
        branch=$(git branch 2> /dev/null | grep \* | colrm 1 2)
        [ ! -z $branch ] && echo "($branch) "
    }'';
    nh =  ''{
        nohup $@ &> /dev/null &
    }'';
    zread = ''{
        nh zathura $@
    }'';
    nsh = ''{
        path="$CONFIG_PATH/nix/shells"
        sh="$path/$1.nix"

        if [ -f "$sh" ]; then
            nix-shell "$sh"
        else
            echo "Shell not found. Available shells:"
            ls "$path"/*.nix
        fi
    }'';
};

sources = {
    "$(nix path-info nixpkgs#zinit | grep -v man)/share/zinit" = "zinit.zsh";
};

opts = {
    prompt_subst = "";
    appendhistory = "";
    sharehistory = "";
    hist_ignore_space = "";
    hist_ignore_all_dups = "";
    hist_ignore_dups = "";
    hist_save_no_dups = "";
    hist_find_no_dups = "";
};

styles = {
    "':completion:*' matcher-list 'm:{a-z}={A-Za-z}'" = "";
    "':completion:*' menu no"= "";
    "':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'"= "";
    "':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'"= "";
};

binds = {
    "^[[1;3C" = "forward-word";
    "^[[1;3D" = "backward-word";
    "^[[1;5C" = "forward-word";
    "^[[1;5D" = "backward-word";
    "^[^?" = "backward-kill-word";
    "^H" = "backward-kill-word";
    "^R" = "history-incremental-search-backward";
    "^F" = "fcd_widget";
    "^P" = "history-search-backward";
    "^N" = "history-search-forward";
};

env = {
    CONFIG_PATH = "~/config";
    HISTDUP = "erase";
    EDITOR = "nvim";
};

envPath = {
    "$HOME/.go" = "bin";
    "$HOME/.bun" = "bin";
};

plugins = {
    "Aloxaf/fzftab" = "\neval \"$(fzf --zsh)\"";
};

PS1 = "'%F{blue}%~ %f$(git_branch)%(?.%F{green}.%F{red})%#%f '";

toShellStatements = { keyword, separator, quoteValue, kvp, quoteKeyIfSpecial ? false, terminator ? "\n" }:
pkgs.lib.concatStringsSep "${terminator}" (pkgs.lib.mapAttrsToList (n: v:
            let
            isSimpleIdentifier = pkgs.lib.match "[a-zA-Z0-9_]+" n == [ n ];
            finalKey = if quoteKeyIfSpecial && !isSimpleIdentifier
            then ''"${n}"''
            else if keyword == "bindkey" && !(n == "Backspace" || n == "Delete" || n == "Enter" || n == "Tab" || n == "Space")
            then ''"${n}"''
            else n;
            valuePart = if quoteValue then ''"${v}"'' else v;
            in
            ''${keyword}${finalKey}${separator}${valuePart}''
            ) kvp);

envString = toShellStatements {
    keyword = "";
    separator = "=";
    quoteValue = false;
    kvp = env;
    quoteKeyIfSpecial = false;
};
aliasesString = toShellStatements {
    keyword = "alias ";
    separator = "=";
    quoteValue = true;
    kvp = aliases;
};
optsString = toShellStatements {
    keyword = "setopt ";
    separator = "";
    quoteValue = false;
    kvp = opts;
    quoteKeyIfSpecial = false;
};
stylesString = toShellStatements {
    keyword = "zstyle ";
    separator = "";
    quoteValue = false;
    kvp = styles;
    quoteKeyIfSpecial = false;
};
bindsString = toShellStatements {
    keyword = "bindkey ";
    separator = " ";
    quoteValue = false;
    kvp = binds;
    quoteKeyIfSpecial = true;
};
pathString = ''${toShellStatements {
    keyword = "";
    separator = "/";
    quoteValue = false;
    kvp = envPath;
    terminator = ":";
    quoteKeyIfSpecial = false;}}$PATH'';
functionsString = toShellStatements {
    keyword = "function ";
    separator = "() ";
    quoteValue = false;
    kvp = functions;
    quoteKeyIfSpecial = false;
};
sourcesString = toShellStatements {
    keyword = "source ";
    separator = "/";
    quoteValue = false;
    kvp = sources;
    quoteKeyIfSpecial = false;
};
pluginsString = toShellStatements {
    keyword = "zinit light ";
    separator = "";
    quoteValue = false;
    kvp = plugins;
    quoteKeyIfSpecial = false;
};
in
with variables; {
    environment.systemPackages = with pkgs; [ stow fzf zinit zoxide git ];

    programs.zsh = {
        enable = true;
        # enableCompletion = true;
        # enableBashCompletion = true;
        # enableAutosuggestions = true;
        # enableSyntaxHighlighting = true;
        # enableFzfCompletion = true;
        # variables = {
        #     DYLD_LIBRARY_PATH = "/usr/local/lib";
        # };
        promptInit = ''
        ${sourcesString}

        PATH="${pathString}"

        ${optsString}

        ${envString}

        ${aliasesString}

        ${bindsString}

        ${functionsString}

        ${pluginsString}

        ${stylesString}

        eval "$(zoxide init zsh)"

        PS1=${PS1}
        '';
    };

    users.users."${user}".shell = pkgs.zsh;
}
