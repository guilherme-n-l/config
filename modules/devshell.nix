{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # `nix develop` brings in the pre-commit runner plus the formatters and
      # linters that .pre-commit-config.yaml references (language: system), and
      # installs the git hook on entry.
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          pre-commit

          # nix
          nixfmt
          deadnix

          # shell
          shfmt
          shellcheck

          # lua
          stylua

          # markdown
          prettier
        ];

        shellHook = ''
          pre-commit install --install-hooks >/dev/null 2>&1 || true
        '';
      };
    };
}
