{ ... }:
{
  # nix-homebrew = {
  #   enable = true;
  #   enableRosetta = true;
  #   mutableTaps = false;
  # };

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation.cleanup = "zap";
  };
}
