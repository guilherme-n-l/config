{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  mypkgs = inputs.self.packages.${system};
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
