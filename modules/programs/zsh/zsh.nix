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
      packages.zsh =
        (self.inputs.wrappers.wrappers.zsh.apply {
          inherit pkgs;
          zdotdir = ./.;
          zshrc.content = ''
            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          '';
        }).wrapper;
    };
}
