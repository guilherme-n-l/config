{
  inputs,
  pkgs,
}: {
  pkgs = with pkgs; let
    alias = src: name: alias: (runCommand "link-${alias}" {} ''
      mkdir -p $out/bin
      install -m 0755 ${src}/bin/${name} $out/bin/${alias}
    '');
  in
    [
      librewolf
      (alias librewolf "librewolf" "lw")
      dmenu
      gcc
      (alias wezterm "wezterm" "wt")
      wezterm
      xclip
      keepassxc
      ripdrag
    ]
    ++ (with inputs; [
      wezterm
    ]);
}
