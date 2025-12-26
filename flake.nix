{
  description = "guilh's nix system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    yap.url = "github:guilherme-n-l/yap?dir=nix";
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };
  outputs =
    inputs:
    with inputs;
    let
      specialArgs = { inherit inputs; };
    in
    {
      darwinConfigurations.air = nix-darwin.lib.darwinSystem {
        modules = [ ./nix/hosts/air ];
        inherit specialArgs;
      };
      nixosConfigurations.work = nixpkgs.lib.nixosSystem {
        modules = [ ./nix/hosts/work ];
        inherit specialArgs;
      };
    }
    // (import ./nix/apps/install.nix specialArgs); # nix run .#install
}
