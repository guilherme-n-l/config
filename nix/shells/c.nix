{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    (
      if builtins.currentSystem == "aarch64-darwin"
      then clang
      else gcc
    )
    pkg-config
    llvmPackages_20.clang-tools
    lldb
  ];
  shellHook = builtins.readFile ./c.sh;
}
