{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  mypkgs = inputs.self.packages.${system};

  zsh = (mypkgs.zsh.passthru.configuration.apply {
    homebrew = config.darwin.zsh.homebrew;
  }).wrapper;
in
{
  options.darwin.zsh = {
    homebrew = lib.mkEnableOption "homebrew shell env";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = zsh;
      description = "The configured zsh wrapper package";
    };
  };

  config = {
    programs.zsh.enable = true;
    environment.systemPackages = [ config.darwin.zsh.package ];
  };
}
