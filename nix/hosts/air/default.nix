{ self, cenfig, nixpkgs, nix-homebrew, homebrew-cask, ... }:

let
user = "guilh";
pkgs = import nixpkgs {
	system = "aarch64-darwin";
	config.allowUnfree = true;
};
packages = import ./packages.nix { inherit pkgs; };
in
{
	imports = [
		nix-homebrew.darwinModules.nix-homebrew
		./preferences.nix
		./../../modules/shared
	];

	config = {
		system = {
			primaryUser = user;
			configurationRevision = self.rev or self.dirtyRev or null;
			stateVersion = 6;
		};

		nix-homebrew = {
			inherit user;
			enable = true;
			enableRosetta = true;
			taps = {
				"homebrew/homebrew-cask" = homebrew-cask;
			};
			mutableTaps = false;
		};

		homebrew = {
			enable = true;
			casks = packages.casks;
			caskArgs.no_quarantine = true;
		};

		nixpkgs.hostPlatform = "aarch64-darwin";
		environment.systemPackages = packages.pkgs;
	};
	
}
