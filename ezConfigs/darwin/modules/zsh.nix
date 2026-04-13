{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  mypkgs = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
  brewShellEnv = ''
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  '';
  zsh =
    if config.darwin.zsh.homebrew then
      (mypkgs.zsh.passthru.configuration.apply {
        zshrc.content = brewShellEnv;
      }).wrapper
    else
      mypkgs.zsh;
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
    environment.systemPackages = [ zsh ];
  };
}
