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
          runtimePkgs = with pkgs; [
            lua-language-server
            stylua

            bash-language-server
            shellcheck
            shfmt

            tree-sitter
          ];
          settings.config_directory = ./.;
        }).wrapper;
    };
}
