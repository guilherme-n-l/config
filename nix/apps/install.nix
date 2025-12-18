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
          functionName = "install_config";
          script = pkgs.writeScriptBin functionName ''
            #!${pkgs.zsh}/bin/zsh
            ${(import ../modules/shared/usrShell.nix { inherit pkgs; }).programs.zsh.promptInit}
            PATH=${pkgs.stow}:$PATH
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
