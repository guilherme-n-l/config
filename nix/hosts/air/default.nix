{ self, config, nixpkgs, nix-homebrew, homebrew-cask, ... }:

let
variables = import ./../../modules/shared/variables.nix;

pkgs = import nixpkgs {
	system = variables.darwinArch;
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
		nix-homebrew = {
			user = variables.user ;
			enable = true;
			enableRosetta = true;
			taps = { "homebrew/homebrew-cask" = homebrew-cask; };
			mutableTaps = false;
		};

		homebrew = {
			enable = true;
			casks = packages.casks;
			caskArgs.no_quarantine = true;
		};

		nixpkgs.hostPlatform = variables.darwinArch;
		environment.systemPackages = packages.pkgs;
	};
	
}
