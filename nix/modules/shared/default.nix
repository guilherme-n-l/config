{ config, pkgs, ... }:

{
	nix.settings.experimental-features = "nix-command flakes";

	environment.systemPackages = with pkgs; [
		neovim
			git
			lazygit
			curl
			wget
			yazi
	];

	fonts.packages = with pkgs; [
		nerd-fonts.fira-code
	];

}

