{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    typst
    tinymist
    typstfmt
    websocat
  ];
  shellHook = builtins.readFile ./typst.sh;
}
