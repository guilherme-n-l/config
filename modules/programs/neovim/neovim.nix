{
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      wrapperPkgs,
      ...
    }:
    {
      packages.neovim =
        (self.inputs.wrappers.wrappers.neovim.apply {
          pkgs = wrapperPkgs;
          extraPackages = with pkgs; [
            lua-language-server
            stylua
          ];
          settings.config_directory = ./.;
        }).wrapper;
    };
}
