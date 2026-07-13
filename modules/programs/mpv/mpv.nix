{ self, ... }:
{
  perSystem =
    { pkgs, wrapperPkgs, ... }:
    let
      mpv = self.inputs.wrappers.wrappers.mpv.apply {
        pkgs = wrapperPkgs;
      };
      wrappedMpv = mpv.wrap {
        "mpv.conf".path = ./mpv.conf;
        "mpv.conf".content = "";
      };
      darwinMpv =
        pkgs.runCommand "mpv-wrapped"
          {
            nativeBuildInputs = [
              pkgs.makeWrapper
              pkgs.makeBinaryWrapper
            ];
          }
          ''
            cp -R ${wrappedMpv} "$out"
            chmod -R u+w "$out"
            makeWrapper ${wrapperPkgs.mpv}/bin/mpv "$out/bin/mpv" \
              --add-flags "--include=${./mpv.conf}"
            mv "$out/Applications/mpv.app/Contents/MacOS/mpv" \
              "$out/Applications/mpv.app/Contents/MacOS/.mpv-wrapped"
            makeBinaryWrapper "$out/Applications/mpv.app/Contents/MacOS/.mpv-wrapped" \
              "$out/Applications/mpv.app/Contents/MacOS/mpv" \
              --add-flags "--include=${./mpv.conf}"
          '';
    in
    {
      packages.mpv = if pkgs.stdenv.isDarwin then darwinMpv else wrappedMpv;
    };
}
