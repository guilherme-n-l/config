{ ... }:
{
  homebrew = {
    enable = true;
    # caskArgs.no_quarantine = true;
    onActivation.cleanup = "zap";
  };
}
