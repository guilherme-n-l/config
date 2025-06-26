{pkgs, ...}: {
  imports = [./usrShell.nix];

  nix.settings.experimental-features = "nix-command flakes";

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
  ];

  fonts.packages = with pkgs; [nerd-fonts.fira-code];
}
