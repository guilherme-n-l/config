{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.flake-init = pkgs.writeShellApplication {
        name = "flake-init";
        runtimeEnv.TEMPLATE = ./_flake.nix;
        text = builtins.readFile ./flake-init.sh;
      };
    };
}
