{
  inputs,
  nixpkgs,
  ...
}: let
  variables = import ./../../modules/shared/variables.nix;

  pkgs = import nixpkgs {
    system = variables.darwinArch;
    config.allowUnfree = true;
  };

  packages = import ./packages.nix {inherit inputs pkgs;};
in {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ./preferences.nix
    ./../../modules/shared
  ];

  config = {
    system = with variables; {
      primaryUser = user;
      configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
      stateVersion = 6;
    };

    users.users = with variables; {
      "${user}" = {
        name = user;
        home = "/Users/" + user;
        uid = 501;
        createHome = true;
      };
    };

    nix-homebrew = with variables; {
      user = user;
      enable = true;
      enableRosetta = true;
      taps = packages.taps;
      mutableTaps = false;
    };

    homebrew = with packages; {
      enable = true;
      inherit brews casks;
      caskArgs.no_quarantine = true;
      onActivation.cleanup = "zap";
      taps = builtins.attrNames taps;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableFzfCompletion = true;
      variables = {DYLD_LIBRARY_PATH = "/usr/local/lib";};
    };

    nixpkgs.hostPlatform = variables.darwinArch;
    environment.systemPackages = packages.pkgs;
  };
}
