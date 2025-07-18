{pkgs}: {
  pkgs = with pkgs; [
    ffmpeg
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
