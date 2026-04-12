{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    ez-configs.url = "github:ehllie/ez-configs";
    import-tree.url = "github:vic/import-tree";

    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = with inputs; [
        (import-tree ./modules)
        ez-configs.flakeModule
      ];

      ezConfigs =
        let
          root = ./ezConfigs;
          darwinRoot = "${root}/darwin";
        in
        {
          inherit root;
          globalArgs = { inherit inputs; };
          earlyModuleArgs = {
            shared = import ./shared;
          };
          darwin = {
            modulesDirectory = "${darwinRoot}/modules";
            configurationsDirectory = "${darwinRoot}/configurations";
          };
        };
    };

}
