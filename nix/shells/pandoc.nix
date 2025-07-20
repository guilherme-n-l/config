{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [pandoc tree-sitter nodejs texlive.combined.scheme-full texlivePackages.collection-latexextra];
  shellHook = with builtins; readFile ./pandoc.sh;
}
