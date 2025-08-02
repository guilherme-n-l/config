{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [rustc rust-analyzer cargo];
  shellHook = builtins.readFile ./rust.sh;
}
