{ self, inputs, pkgs, ... }:

let
variables = import ./variables.nix;
in
with variables; {
    imports = [ ./usrShell.nix ];

    nix.settings.experimental-features = "nix-command flakes";

    system = {
        primaryUser = user;
        configurationRevision = self.rev or self.dirtyRev or null;
        stateVersion = 6;
    };

    users.users = {
        "${user}" = {
            name = user;
            home = "/Users/" + user;
            uid = 501;
            createHome = true;
        };
    };

    environment.systemPackages = with pkgs; [
        neovim
            git
            lazygit
            curl
            wget
            yazi
            fzf
            fd
            stow
            tree
            ripgrep
            zoxide
            inputs.wezterm.packages.${pkgs.system}.default
    ];

    fonts.packages = with pkgs; [
        nerd-fonts.fira-code
    ];
}
