{ shared, pkgs, inputs, ... }:
let
  sharedEnv = shared { inherit pkgs inputs; };
in
{
  environment.systemPackages = sharedEnv.packages;
}
