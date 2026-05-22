{ self, ... }:
{
  config = {
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    perSystem =
      { pkgs, system, ... }:
      {
        _module.args.wrapperPkgs = import self.inputs.nixpkgs {
          inherit system;
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (pkgs.lib.getName pkg) [
              "replace"
            ];
        };
      };
  };
}
