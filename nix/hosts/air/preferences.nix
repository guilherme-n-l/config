{ config, lib, ... }:

{
  system.defaults = {
    dock = {
      persistent-apps = [];
      persistent-others = [];
      orientation = "left";
      tilesize = 53;
      autohide = true;
      showhidden = true;
    };

    NSGlobalDomain = {
      "com.apple.keyboard.fnState" = true;
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 18;
    };

    CustomUserPreferences = {
      "NSGlobalDomain"."NSUserKeyEquivalents" = {
        "Launch Terminal" = "@$t";
      };
    };

  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
