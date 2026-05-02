{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      mpv = self.inputs.wrappers.wrappers.mpv.apply { inherit pkgs; };
    in
    {
      packages.mpv = mpv.wrap {
        "mpv.conf".path = ./mpv.conf;
        "mpv.conf".content = "";
      };
    };
}
