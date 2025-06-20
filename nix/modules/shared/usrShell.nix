{ pkgs, ... }:

let
variables = import ./variables.nix;
aliases = {
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

# Nix
    
};

functions = {
    rebuild = ''{
        stow --dir=$CONFIG_PATH/dotfiles --target=$HOME ;\
        sudo darwin-rebuild switch --flake $CONFIG_PATH/#$1
    }'';
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
};
envPath = {
    "$HOME/.go" = "bin";
    "$HOME/.bun" = "bin";
};
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
aliasesString = toShellStatements {
    keyword = "alias ";
    separator = "=";
    quoteValue = true;
    kvp = aliases;
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
    in
    with variables; {
        environment.systemPackages = with pkgs; [ stow fzf ];

        programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableBashCompletion = true;
            enableAutosuggestions = true;
            enableSyntaxHighlighting = true;
            enableFzfCompletion = true;
            variables = {
                DYLD_LIBRARY_PATH = "/usr/local/lib";
                EDITOR = "nvim";
                CONFIG_PATH = "~/config";
            };
            promptInit = ''
            PATH="${pathString}"

            ${aliasesString}

            ${bindsString}

            ${functionsString}
            '';
        };

        users.users."${user}".shell = pkgs.zsh;
    }
