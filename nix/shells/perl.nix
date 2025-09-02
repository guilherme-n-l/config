{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [perl] ++ (with perl540Packages; [PLS LogLog4perl PerlTidy]);
  shellHook = builtins.readFile ./perl.sh;
}
