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

      ffmpeg
      yt-dlp

      nodejs_22
    ])
    ++ (with mypkgs; [
      neovim
      mpv
    ])
    ++ [ inputs.fc.packages.${system}.default ];

  fonts = with pkgs.nerd-fonts; [
    fira-code
  ];
}
