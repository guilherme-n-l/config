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
            bash-language-server
            shellcheck
            shfmt
          ];
          settings.config_directory = ./.;
        }).wrapper;
    };
}
