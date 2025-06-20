{ config, lib, ... }:

{
    system.defaults = {
        finder.FXPreferredViewStyle = "clmv";

        dock = {
            persistent-apps = [];
            persistent-others = [];
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

    system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
    };
}
