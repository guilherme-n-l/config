{
  inputs,
  pkgs,
  ...
}: {
  imports = [./usrShell.nix];

  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = import ./packages.nix {inherit inputs pkgs;};

  fonts.packages = with pkgs; [nerd-fonts.fira-code];
}
