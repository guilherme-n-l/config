{ pkgs, ... }:
{
  packages = with pkgs; [
    # NIX LSP
    nixd
    nixfmt

    # LUA LSP
    luajitPackages.lua-lsp
    stylua

    # SHELL DEPENDENCIES
    fd
    fzf
    zsh-fzf-tab
    stow
    gnugrep
    git
    zoxide
    ripgrep
    tree
    tealdeer
    lazygit
    curl
    wget
    neovim
    yazi
    ffmpeg
  ];
}
