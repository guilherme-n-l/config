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

    # LUA LSP
    luajitPackages.lua-lsp
    stylua

    # NIX LSP
    nil
    alejandra
  ];
}
