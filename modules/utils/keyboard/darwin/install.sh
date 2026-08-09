# shellcheck shell=bash

BUNDLE=${BUNDLE:?set via runtimeEnv (path to Guilh.bundle)}
dest="/Library/Keyboard Layouts/Guilh.bundle"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "error: macOS only" >&2
  exit 1
fi

# Same destination the nix-darwin activation script uses, so running this by
# hand and running `darwin-rebuild switch` cannot leave two copies behind.
if diff -rq "$BUNDLE" "$dest" >/dev/null 2>&1; then
  echo "Guilh keyboard layouts already up to date."
  exit 0
fi

echo "Installing Guilh keyboard layouts -> $dest (needs root)..."
sudo rm -rf "$dest"
sudo mkdir -p "$(dirname "$dest")"
sudo cp -R "$BUNDLE" "$dest"
# The store copy is read-only; restore the perms loginwindow expects.
sudo find "$dest" -type d -exec chmod 755 {} +
sudo find "$dest" -type f -exec chmod 644 {} +

echo "Done. Enable them under System Settings > Keyboard > Text Input >"
echo "Input Sources > Edit... > + > Portuguese / English ('BR - Guilh',"
echo "'US - Guilh'). Log out and back in if they do not show up yet."
