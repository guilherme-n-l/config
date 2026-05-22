{ self, ... }:
{
  perSystem =
    { wrapperPkgs, ... }:
    let
      mpv = self.inputs.wrappers.wrappers.mpv.apply { pkgs = wrapperPkgs; };
    in
    {
      packages.mpv = mpv.wrap {
        "mpv.conf".path = ./mpv.conf;
        "mpv.conf".content = "";
      };
    };
}
