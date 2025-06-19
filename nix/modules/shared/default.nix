{ self, config, pkgs, user, ... }:

let
variables = import ./variables.nix;
in
{
	nix.settings.experimental-features = "nix-command flakes";

	system = {
		primaryUser = variables.user;
		configurationRevision = self.rev or self.dirtyRev or null;
		stateVersion = 6;
	};

	environment.systemPackages = with pkgs; [
		neovim
			git
			lazygit
			curl
			wget
			yazi
			fzf
			fd
	];

	fonts.packages = with pkgs; [
		nerd-fonts.fira-code
	];

}
