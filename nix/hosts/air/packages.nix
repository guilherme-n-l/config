{ inputs, pkgs }:
{
  casks = [
    "librewolf"
    "libreoffice"
    "mpv"
    "desktoppr"
    "keepassxc"
    "darktable"
    "calibre"
    "wezterm@nightly"
    "gimp"
    "spotify"
  ];

  brews = [
    "tailscale"
    "clang-format"
  ];

  pkgs = [ ];

  taps = {
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
  };
  # pkgs = with pkgs; [
  # ];
}
