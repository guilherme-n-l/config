{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      version = "1.5.7";

      # Upstream pins aeson < 2 and GHC 8.10.4 (niv), so it does not build
      # against current nixpkgs and is not packaged there either. The official
      # release binaries are x86_64 only; on Apple Silicon this runs under
      # Rosetta. Hashes pin it, so the fetch is still pure.
      release = {
        x86_64-linux = {
          plat = "linux";
          hash = "sha256-8Yh0T0Zrtd7BQCmsMyavKmRkJxHcojt7Ktqzzy8wPK4=";
        };
        x86_64-darwin = {
          plat = "macos";
          hash = "sha256-Y7xAfNWIlRjwAxaUtux4l6bIGxXCfbhmqSkRJ2Pq8PI=";
        };
        aarch64-darwin = {
          plat = "macos";
          hash = "sha256-Y7xAfNWIlRjwAxaUtux4l6bIGxXCfbhmqSkRJ2Pq8PI=";
        };
      };

      inherit (pkgs.stdenv.hostPlatform) system;
      have = release ? ${system};
      this = release.${system};
    in
    {
      packages = pkgs.lib.optionalAttrs have {
        klfc = pkgs.stdenvNoCC.mkDerivation {
          pname = "klfc";
          inherit version;

          src = pkgs.fetchzip {
            url = "https://github.com/39aldo39/klfc/releases/download/v${version}/klfc-${this.plat}-amd64-v${version}.zip";
            inherit (this) hash;
            # the archive is a flat list (klfc, README, examples/), no top dir
            stripRoot = false;
          };

          dontFixup = true;

          installPhase = ''
            runHook preInstall
            install -Dm755 klfc "$out/bin/klfc"
            runHook postInstall
          '';

          meta = {
            description = "Keyboard Layout Files Creator";
            homepage = "https://github.com/39aldo39/klfc";
            license = pkgs.lib.licenses.gpl3Only;
            mainProgram = "klfc";
            platforms = builtins.attrNames release;
          };
        };
      };
    };
}
