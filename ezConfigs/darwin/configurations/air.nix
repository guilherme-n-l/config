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
    inputs
    fonts
    automator
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
        "com.apple.symbolichotkeys"."AppleSymbolicHotKeys" = {
          # "xx" = {
          #   enabled = true;
          #   value = {
          #     parameters = [ <char-code>  <key-code>  <modifier-flags> ];
          #     type = "standard";
          #   };
          # };

          # Move to previous space
          "79" = {
            enabled = true;
            value = {
              parameters = [
                49
                18
                1048576
              ]; # cmd+1
              type = "standard";
            };
          };
          # Move to next space
          "81" = {
            enabled = true;
            value = {
              parameters = [
                50
                19
                1048576
              ]; # cmd+2
              type = "standard";
            };
          };
        };

        "pbs"."NSServicesStatus" = {
          "(null) - Open Finder - runWorkflowAsService" = {
            enabled_context_menu = true;
            enabled_services_menu = true;
            key_equivalent = "@e";
          };
          "(null) - Run Terminal - runWorkflowAsService" = {
            enabled_context_menu = true;
            enabled_services_menu = true;
            key_equivalent = "@$t";
          };
        };
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
      "firefox"

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
      "claude-code@latest"
      "codex"
    ];
  };

  darwin.terminal = "iTerm";

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
