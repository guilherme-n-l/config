{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # Shared key-remap body (the source of truth for the layout).
      body = builtins.readFile ./replaces;

      # An `xkb_symbols "custom"` section, wrapped in markers so the installer
      # can strip + re-append it idempotently. `base` is the layout it extends
      # (e.g. br(abnt2)), so the section is a self-contained variant.
      mkSection = base: name: ''
        // >>> xkbd-custom (managed by `nix run .#xkbd-custom`) — do not edit >>>
        partial alphanumeric_keys
        xkb_symbols "custom" {
            include "${base}"
            name[Group1] = "${name}";

        ${body}
        };
        // <<< xkbd-custom <<<
      '';

      brSection = pkgs.writeText "xkb-br-custom" (
        mkSection "br(abnt2)" "Portuguese (Brazil, ABNT2, custom)"
      );
      usSection = pkgs.writeText "xkb-us-custom" (mkSection "us(basic)" "English (US, custom)");
    in
    {
      # `xkbd-custom` installs a `custom` variant into the system XKB database
      # (symbols/br and symbols/us) so the layout your XFCE session already
      # references (br,us : custom,custom) works at every login. It then
      # reloads the running X session.
      #
      # The symbols live in the nix store; the installer only ever appends a
      # marked block to the two files, idempotently. An `xkeyboard-config`
      # upgrade overwrites those files (that's what broke it originally), so
      # re-run this after such an upgrade to reinstall
      packages.xkbd-custom = pkgs.writeShellApplication {
        name = "xkbd-custom";
        runtimeInputs = with pkgs; [ coreutils ];
        # Script lives in ./install.sh so it stays shellcheck/shfmt-friendly and
        # editable on its own; the wrapper just hands it the generated sections.
        text = ''
          export BR_SECTION="${brSection}"
          export US_SECTION="${usSection}"
          ${builtins.readFile ./install.sh}
        '';
      };
    };
}
