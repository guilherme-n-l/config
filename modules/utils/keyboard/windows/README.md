# Windows layouts

```sh
nix build github:guilherme-n-l/config#keyboard-windows
```

That gives you `result/us/` and `result/abnt2/`, each holding a **PKL** tree and
a **KLC** source. Prefer PKL.

## PKL (recommended, no MSKLC)

[Portable Keyboard Layout][pkl] is a resident AutoHotkey program, so it needs no
admin rights, no reboot, and no MSKLC. Copy `result/<layout>/` onto the Windows
machine and run `pkl.exe`; add a shortcut to `shell:startup` to make it stick.

It is also the only route that carries **CapsLock → Escape**, which the `.klc`
format cannot express at all.

## KLC (fallback, needs MSKLC)

Use this only if you want a real installed layout DLL:

1. [MSKLC][msklc] → **File → Load Source File...** → `result/<layout>/klc/*.klc`
2. **Project → Build DLL and Setup Package**, then run the generated installer.

The `.klc` files are re-encoded to UTF-16LE with a BOM and CRLF endings on the
way out, because that is what MSKLC accepts and KLFC writes plain UTF-8.

Two things do not survive this route: CapsLock → Escape (above), and the
`ABNT_C1` key on ABNT2 (`/` `?`), which KLFC cannot emit for KLC or PKL — see
[klfc#45][i45]. Both are fine in the XKB and macOS outputs.

[pkl]: http://pkl.sourceforge.net/
[msklc]: https://www.microsoft.com/en-us/download/details.aspx?id=102134
[i45]: https://github.com/39aldo39/klfc/issues/45
