{inputs, pkgs}: {
  casks = [
    "librewolf"
    "libreoffice"
    "desktoppr"
    "keepassxc"
    "darktable"
    "calibre"
    "wezterm@nightly"
    "gimp"
  ];

  brews = [
    "tailscale"
  ];

  pkgs = [];

  taps = {"homebrew/homebrew-cask" = inputs.homebrew-cask;};
  # pkgs = with pkgs; [
  # ];
}
