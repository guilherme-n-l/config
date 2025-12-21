{ inputs }: # Requires: nixpkgs flake-utils
let
in
with inputs;
{
  apps =
    let
      install = (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          utils = import ../modules/shared/utils.nix { inherit pkgs; };
          functionName = "install_config";
          configPath = "CONFIG_PATH";
          script =
            with utils;
            pkgs.writeScriptBin functionName ''
              #!${pkgs.zsh}/bin/zsh
              ${mkShellVariables {
                vars."${configPath}" = (import ../modules/shared/shell/env.nix).${configPath};
              }}
              ${mkShellFunctions {
                "${functionName}" = (import ../modules/shared/shell/functions.nix).${functionName};
              }}
              PATH=${pkgs.stow}/bin:$PATH
              ${functionName}
            '';
        in
        {
          type = "app";
          program = "${script}/bin/${functionName}";
        }
      );
    in
    builtins.listToAttrs (
      map (x: {
        name = x;
        value = {
          install = install x;
        };
      }) flake-utils.lib.defaultSystems
    );
}
