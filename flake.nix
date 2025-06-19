{
	description = "nix-darwin system flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nix-darwin.url = "github:nix-darwin/nix-darwin/master";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
		nix-homebrew.url = "github:zhaofengli/nix-homebrew";
        wezterm.url = "github:wezterm/wezterm?dir=nix";

		homebrew-cask = {
			url = "github:homebrew/homebrew-cask";
			flake = false;
		};
	};

	outputs = inputs@{ self, nix-darwin, ... }:
	{
		darwinConfigurations = {
			air = nix-darwin.lib.darwinSystem { 
				modules = [ ./nix/hosts/air ];
				specialArgs = { inherit self inputs; };
			};
		};
	};
}

