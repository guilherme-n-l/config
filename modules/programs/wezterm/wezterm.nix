{ self, ... }:
{
  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      packages.wezterm =
        let
          nixgl = inputs'.nixgl.packages;
          wezterm =
            (self.inputs.wrappers.wrappers.wezterm.apply {
              inherit pkgs;
              "wezterm.lua".path = ./wezterm.lua;
              luaInfo.configDir = "${placeholder "out"}/wezterm-config";
              constructFiles =
                let
                  mkEntries = dir:
                    let
                      files = builtins.filter
                        (f: builtins.match ".*\\.lua" f != null)
                        (builtins.attrNames (builtins.readDir ./${dir}));
                    in
                    builtins.listToAttrs (map (f: {
                      name = "${dir}/${f}";
                      value = {
                        relPath = "wezterm-config/${dir}/${f}";
                        content = builtins.readFile ./${dir}/${f};
                      };
                    }) files);
                in
                builtins.foldl' (acc: dir: acc // mkEntries dir) { } [ "config" "utils" ];
            }).wrapper;
        in
        pkgs.writeShellScriptBin "wezterm" ''
          exec ${nixgl.nixGLIntel}/bin/nixGLIntel ${wezterm}/bin/wezterm "$@"
        '';
    };
}
