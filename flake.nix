{
  description = "guilh's nix system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    yap.url = "github:guilherme-n-l/yap?dir=nix";
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs: {
    darwinConfigurations = {
      air = inputs.nix-darwin.lib.darwinSystem {
        modules = [./nix/hosts/air];
        specialArgs = {inherit inputs;};
      };
    };
    nixosConfigurations = {
      work = inputs.nixpkgs.lib.nixosSystem {
        modules = [./nix/hosts/work];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
