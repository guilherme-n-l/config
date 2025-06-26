{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [pandoc texlive.combined.scheme-small];
  shellHook = with builtins; readFile ./pandoc.sh;
}
