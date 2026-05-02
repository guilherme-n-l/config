{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.zsh =
        (self.inputs.wrappers.wrappers.zsh.apply {
          inherit pkgs;
          zdotdir = ./.;
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
          env.FZF_KEY_BINDINGS = "${pkgs.fzf}/share/fzf/key-bindings.zsh";
          env.ZSH_FZF_TAB_PLUGIN = "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh";
          env.ZSH_SYNTAX_HIGHLIGHTING_PLUGIN = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        }).wrapper;
    };
}
