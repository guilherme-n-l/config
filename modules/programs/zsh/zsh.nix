{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.zsh =
        (self.inputs.wrappers.wrappers.zsh.apply {
          inherit pkgs;
          zdotdir = ./.;
          zshrc.content = ''
            source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          '';
          extraPackages = with pkgs; [
            # Utils
            git
            tealdeer
            lazygit

            # Media
            curl
            wget
            ffmpeg

            # Text
            gnugrep
            ripgrep
            glow

            # Nav
            tree
            fd
            fzf
            zsh-fzf-tab
            zoxide
            yazi

            # LSP / Lint / Format
            shellcheck
            shfmt
          ];
        }).wrapper;
    };
}
