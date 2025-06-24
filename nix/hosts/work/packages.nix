{ inputs, pkgs }:

{
  pkgs = with pkgs; [
    librewolf
    dmenu
    gcc
    wezterm
    xclip
    keepassxc
  ] ++ [
    inputs.wezterm
  ];
}
