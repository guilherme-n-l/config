{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    rustc
    rust-analyzer
    rustfmt
    cargo
    lldb
    clippy
  ];
  shellHook = builtins.readFile ./rust.sh;
}
