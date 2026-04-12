{ inputs, pkgs, ... }:
let
  mypkgs = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  packages =
    (with pkgs; [
      # NIX LSP
      nixd
      nixfmt

      # LUA LSP
      lua-language-server
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
      yazi
      ffmpeg
    ])
    ++ (with mypkgs; [
      neovim
    ]);
}
