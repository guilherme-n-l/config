{ self, ... }:
{
  perSystem =
    {
      pkgs,
      wrapperPkgs,
      ...
    }:
    {
      packages.ripgrep = self.inputs.wrappers.lib.wrapPackage {
        pkgs = wrapperPkgs;
        package = pkgs.ripgrep;
        flags = {
          "--hidden" = true;
          "--smart-case" = true;
        };
      };
    };
}
