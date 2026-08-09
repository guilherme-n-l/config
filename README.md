# Personal config

## Current available flake modules

```sh
github:guilherme-n-l/config#neovim
github:guilherme-n-l/config#zsh
github:guilherme-n-l/config#ripgrep
github:guilherme-n-l/config#yazi
github:guilherme-n-l/config#mpv
github:guilherme-n-l/config#wezterm # Uses NixGL
github:guilherme-n-l/config#claude-config # Syncs ~/.claude config
github:guilherme-n-l/config#flake-init # Personal flake scaffold
```

## Keyboard layouts

One custom AltGr/Option symbol layer, every platform, generated from a single
source by [KLFC](https://github.com/39aldo39/klfc).

```sh
nix run   github:guilherme-n-l/config#keyboard-linux   # XKB br,us : custom,custom
nix run   github:guilherme-n-l/config#keyboard-darwin  # /Library/Keyboard Layouts
nix build github:guilherme-n-l/config#keyboard-windows # PKL (+ .klc fallback)
```

Sources live in [`modules/utils/keyboard/layouts`](modules/utils/keyboard/layouts)
and compose: a `meta/` file, a `base/`, then the shared `mod3.json` (the symbol
layer) and `capslock.json` (CapsLock → Escape).

| layout          | composed from                               | for                        |
| --------------- | ------------------------------------------- | -------------------------- |
| `US - Guilh`    | `base/us` + mod3 + capslock                 | ANSI                       |
| `BR - Guilh`    | `base/us` + `pt-deadkeys` + mod3 + capslock | ANSI, Portuguese dead keys |
| `ABNT2 - Guilh` | `base/abnt2` + mod3 + capslock              | external ABNT2 board       |

Editing `mod3.json` changes the symbol layer everywhere at once.

`keyboard-linux` is still aliased as `xkbd-custom`. macOS is also installed
declaratively on `darwin-rebuild switch` — same bundle, same path — so `nix run`
is only the shortcut. For Windows see
[`windows/README.md`](modules/utils/keyboard/windows/README.md); PKL needs no
MSKLC.
