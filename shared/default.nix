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
    ])
    ++ (with mypkgs; [
      neovim
      zsh
    ]);
}
