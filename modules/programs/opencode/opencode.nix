{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      opencodeConfig = ./.opencode;
    in
    {
      # `opencode-config` copies the tracked files under ./.opencode into
      # $HOME/.config/opencode so the repo stays the source of truth. Only
      # files we track are overwritten; opencode's own runtime state
      # (credentials, sessions, kv.json, ...) is left untouched.
      #
      # Run it whenever you rebuild, e.g.
      #   nix run github:guilherme-n-l/config#opencode-config
      packages.opencode-config = pkgs.writeShellApplication {
        name = "opencode-config";
        runtimeInputs = with pkgs; [
          coreutils
          findutils
        ];
        # Script lives in ./sync.sh so it stays shellcheck/shfmt-friendly and
        # editable on its own; the wrapper just hands it the source tree.
        text = ''
          export SRC="${opencodeConfig}"
          ${builtins.readFile ./sync.sh}
        '';
      };
    };
}
