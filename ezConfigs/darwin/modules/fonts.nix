{
  shared,
  pkgs,
  inputs,
  ...
}:
let
  sharedEnv = shared { inherit pkgs inputs; };
in
{
  fonts.packages = sharedEnv.fonts;
}
