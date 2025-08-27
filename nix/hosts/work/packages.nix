{
  inputs,
  pkgs,
}: let
  alias = src: name: alias: (pkgs.runCommand "link-${alias}" {} ''
    mkdir -p $out/bin
    install -m 0755 ${src}/bin/${name} $out/bin/${alias}
  '');
in
  with pkgs; [
    librewolf
    (alias librewolf "librewolf" "lw")
    dmenu
    gcc
    wezterm
    xclip
    keepassxc
    ripdrag
    unzip
    wezterm
    (alias wezterm "wezterm" "wt")
  ]
