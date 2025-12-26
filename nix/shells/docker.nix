{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    docker
    colima
  ];
  shellHook = with builtins; readFile ./docker.sh;
}
