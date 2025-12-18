{
  pkgs ? import <nixpkgs> { },
}:
[
  "$HOME/.go/bin"
  "$HOME/.bun/bin"
  "$HOME/.local/bin"
  "${pkgs.nodejs_24}/bin"
]
