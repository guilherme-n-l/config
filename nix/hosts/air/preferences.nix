{ config, lib, ... }:

{
	system.defaults.NSGlobalDomain = {
		"com.apple.keyboard.fnState" = true;
		ApplePressAndHoldEnabled = false;
		KeyRepeat = 2;
		InitialKeyRepeat = 18;
	};
}
