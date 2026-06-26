src=${SRC:?must be set by the nix wrapper (path to the tracked .claude tree)}
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

echo "Syncing .claude config..."
while IFS= read -r -d "" rel; do
    rel="${rel#./}"
    mkdir -p "$dest/$(dirname "$rel")"
    cp -fL "$src/$rel" "$dest/$rel"
    chmod u+w "$dest/$rel"
    echo "  $rel"
done < <(cd "$src" && find . -mindepth 1 -type f -print0)
