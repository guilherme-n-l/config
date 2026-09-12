#!/usr/bin/env bash
# Injected into a writeShellApplication wrapper that sets `set -euo pipefail`

src=${SRC:?must be set by the nix wrapper (path to the tracked .opencode tree)}
dest="$HOME/.config/opencode"

echo "Syncing opencode config..."
while IFS= read -r -d "" rel; do
  rel="${rel#./}"
  mkdir -p "$dest/$(dirname "$rel")"
  cp -fL "$src/$rel" "$dest/$rel"
  chmod u+w "$dest/$rel"
  echo "  $rel"
done < <(cd "$src" && find . -mindepth 1 -type f -print0)
