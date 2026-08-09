{ inputs, pkgs, ... }:
let
  # Generated from modules/utils/keyboard/layouts by KLFC. `nix run
  # .#keyboard-darwin` installs the very same bundle to the very same path, so
  # the declarative and imperative routes can never disagree.
  bundle = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.keyboard-darwin-bundle;
  dest = "/Library/Keyboard Layouts/Guilh.bundle";
in
{
  system.activationScripts.postActivation.text = ''
    echo "keyboard layouts: checking ${dest}..."
    src="${bundle}"
    if ! diff -rq "$src" "${dest}" &>/dev/null 2>&1; then
      echo "Installing Guilh keyboard layout..."
      rm -rf "${dest}"
      cp -r "$src" "${dest}"
      find "${dest}" -type d -exec chmod 755 {} +
      find "${dest}" -type f -exec chmod 644 {} +
    else
      echo "Guilh keyboard layout already up to date."
    fi
  '';
}
