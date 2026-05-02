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

  brewShellEnv = ''
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  '';

  zsh = (mypkgs.zsh.passthru.configuration.apply {
    zshrc.content = lib.optionalString config.darwin.zsh.homebrew brewShellEnv;
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
