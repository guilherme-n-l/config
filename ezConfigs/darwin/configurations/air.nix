{
  ezModules,
  config,
  ...
}:
let
  user = "guilh";
in
{
  imports = with ezModules; [
    packages
    homebrew
    zsh
  ];

  system = {
    primaryUser = user;
    stateVersion = 6;
    defaults = {
      finder.FXPreferredViewStyle = "clmv";

      dock = {
        persistent-apps = [ ];
        persistent-others = [ ];
        orientation = "left";
        tilesize = 53;
        autohide = true;
        showhidden = true;
      };

      screencapture.location = "~/Pictures/Screenshots";

      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true;
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 18;
      };

      CustomUserPreferences = {
        "com.apple.CloudSubscriptionFeatures.optIn"."545129924" = false; # Disable Intelligence
        "com.apple.HIToolbox"."AppleFnUsageType" = 0; # Disable fn Lock
        "com.apple.dock"."show-recents" = false; # Disable recentes in dock
        "com.apple.finder"."CreateDesktop" = false; # Hide desktop icons
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  users.knownUsers = [ user ];

  users.users = {
    root.home = "/var/root";
    ${user} = {
      uid = 501;
      shell = config.darwin.zsh.package;
    };
  };

  homebrew = {
    brews = [
    ];
    casks = [
      # Web
      "librewolf"

      # Productivity
      "libreoffice"
      "omnissa-horizon-client"

      # Utils
      "iterm2"
      "keepassxc"
      "macfuse"

      # Design
      "gimp"

      # Fun
      "spotify"

      # AI
      "claude-code"
      "codex"
      "antigravity"
    ];
  };

  darwin.zsh.homebrew = true;

  nix = {
    distributedBuilds = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
}
