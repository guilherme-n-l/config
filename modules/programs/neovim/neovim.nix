{
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.neovim =
        (self.inputs.wrappers.wrappers.neovim.apply {
          inherit pkgs;
          settings.config_directory = ./.;
        }).wrapper;
    };
}
