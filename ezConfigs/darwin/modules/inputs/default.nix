{ ... }:
let
  bundle = ./Guilh.bundle;
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
