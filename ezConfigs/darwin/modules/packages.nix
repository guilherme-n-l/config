{ shared, pkgs, ... }@args:
let
  sharedEnv = shared args;
in
{
  environment.systemPackages = sharedEnv.packages;
}
