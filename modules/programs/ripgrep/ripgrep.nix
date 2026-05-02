{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.ripgrep = self.inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.ripgrep;
        flags = {
          "--hidden" = true;
          "--smart-case" = true;
        };
      };
    };
}
