{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      claudeConfig = ./.claude;
    in
    {
      # `claude-config` copies the tracked files under ./.claude into
      # $HOME/.claude (or $CLAUDE_CONFIG_DIR) so the repo stays the source of
      # truth. Only files we track are overwritten; Claude's own runtime state
      # (credentials, projects, history, todos, ...) is left untouched.
      #
      # Run it whenever you rebuild, e.g.
      #   nix run github:guilherme-n-l/config#claude-config
      packages.claude-config = pkgs.writeShellApplication {
        name = "claude-config";
        runtimeInputs = with pkgs; [
          coreutils
          findutils
        ];
        text = ''
          src=${claudeConfig}
          dest="''${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

          echo "Syncing .claude config..."
          while IFS= read -r -d "" rel; do
            rel="''${rel#./}"
            mkdir -p "$dest/$(dirname "$rel")"
            cp -fL "$src/$rel" "$dest/$rel"
            chmod u+w "$dest/$rel"
            echo "  $rel"
          done < <(cd "$src" && find . -mindepth 1 -type f -print0)
        '';
      };
    };
}
