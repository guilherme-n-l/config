{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [rustc rust-analyzer rustfmt cargo clippy];
  shellHook = builtins.readFile ./rust.sh;
}
