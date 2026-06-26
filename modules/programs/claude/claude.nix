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
        # Script lives in ./sync.sh so it stays shellcheck/shfmt-friendly and
        # editable on its own; the wrapper just hands it the source tree.
        text = ''
          export SRC="${claudeConfig}"
          ${builtins.readFile ./sync.sh}
        '';
      };
    };
}
