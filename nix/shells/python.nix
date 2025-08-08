{pkgs ? import <nixpkgs> {}}: let
  pythonPkgs = with pkgs.python313Packages; [
    virtualenv
    black
    python-lsp-server
    pylint
    isort
    mypy
  ];
in
  pkgs.mkShell {
    buildInputs = pythonPkgs ++ (with pkgs; []);
    shellHook = with builtins; readFile ./python.sh;
  }
