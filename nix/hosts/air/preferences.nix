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
            "com.apple.desktop"."com.apple.desktop.background.showAsScreenSaver" = false;
        };

    };
    system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
    };
}
