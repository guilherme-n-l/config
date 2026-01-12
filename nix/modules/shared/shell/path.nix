let
  # [ "$HOME/[DIR]/bin" ]
  toHomeBinPath =
    list:
    (map (
      x:
      builtins.concatStringsSep "/" [
        "$HOME"
        x
        "bin"
      ]
    ) list);
in
[ ]
++ toHomeBinPath [
  ".npm"
  ".go"
  ".bun"
  ".cargo"
  ".local"
]
