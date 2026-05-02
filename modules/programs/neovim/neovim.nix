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
          extraPackages = with pkgs; [
            bash-language-server
            shellcheck
            shfmt
          ];
          settings.config_directory = ./.;
        }).wrapper;
    };
}
