xkb="/usr/share/X11/xkb/symbols"
BR_SECTION=${BR_SECTION:?must be set by the nix wrapper (path to the generated br 'custom' section)}
US_SECTION=${US_SECTION:?must be set by the nix wrapper (path to the generated us 'custom' section)}
if [ ! -d "$xkb" ]; then
    echo "error: $xkb not found — need an Xorg + xkeyboard-config system" >&2
    exit 1
fi

# Append (or refresh) the marked 'custom' block in a system symbols file.
install_variant() {
    file="$1"
    snippet="$2"
    echo "  installing custom variant -> $xkb/$file"
    sudo sh -c '
              target="$1"; snippet="$2"; tmp="$(mktemp)"
              # Drop any block we installed previously, then append the fresh one.
              sed "/\/\/ >>> xkbd-custom/,/\/\/ <<< xkbd-custom/d" "$target" > "$tmp"
              cat "$snippet" >> "$tmp"
              install -m644 "$tmp" "$target"
              rm -f "$tmp"
            ' _ "$xkb/$file" "$snippet"
}

echo "Installing custom XKB variants (needs root)..."
install_variant br "$BR_SECTION"
install_variant us "$US_SECTION"

if [ -n "${DISPLAY:-}" ] && command -v setxkbmap >/dev/null 2>&1; then
    echo "Reloading session (br,us : custom,custom)..."
    if ! setxkbmap -layout "br,us" -variant "custom,custom" \
        -option terminate:ctrl_alt_bksp; then
        echo "warning: live reload failed — check the section, then log out/in" >&2
    fi
fi

echo "Done. Persists across logins via your XFCE keyboard-layout config."
echo "Re-run after an xkeyboard-config upgrade (it overwrites symbols/br and symbols/us)."
