{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [xdcc-cli];
  shellHook = builtins.readFile ./anime.sh;
}
