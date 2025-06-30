{pkgs}: {
  pkgs = with pkgs; [
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
    tealdeer
    ripdrag
  ];
}
