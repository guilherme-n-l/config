{ shared, pkgs, ... }:
let
  sharedEnv = shared { inherit pkgs; };
in
{
  environment.systemPackages = sharedEnv.packages;
}
