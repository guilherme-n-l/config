{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      kanagawa-dragon = pkgs.fetchFromGitHub {
        owner = "marcosvnmelo";
        repo = "kanagawa-dragon.yazi";
        rev = "b9541e84dc13265548e5bbb12c274b70b381b5cc";
        hash = "sha256-8gtpID6OdvYfRKT0Z2aypDdbBsavCBg2/pcXC7x3vTg=";
      };
    in
    {
      packages.yazi =
        (self.inputs.wrappers.wrappers.yazi.apply {
          inherit pkgs;
          settings = {
            keymap.mgr.prepend_keymap = [
              {
                on = [ "d" ];
                run = "yank --cut";
                desc = "Cut the selected files";
              }
              {
                on = [ "D" ];
                run = "unyank";
                desc = "Cancel the yank status of files";
              }
              {
                on = [ "x" ];
                run = "remove";
                desc = "Move the files to the trash";
              }
              {
                on = [ "X" ];
                run = "remove --permanently";
                desc = "Permanently delete the files";
              }
              {
                on = [ "<C-d>" ];
                run = "plugin drag";
                desc = "Drag and drop utility";
              }
            ];
            theme.flavor.dark = "kanagawa-dragon";

            package = {
              plugin.deps = [
                {
                  use = "Joao-Queiroga/drag";
                  rev = "6b4bc40";
                  hash = "efb404d68fdd43fd3dcc2fd0153a2c95";
                }
              ];
              flavor.deps = [ ];
            };
          };
          constructFiles = {
            kanagawa-dragon-flavor = {
              relPath = "yazi-config/flavors/kanagawa-dragon.yazi/flavor.toml";
              content = builtins.readFile "${kanagawa-dragon}/flavor.toml";
            };
            kanagawa-dragon-tmtheme = {
              relPath = "yazi-config/flavors/kanagawa-dragon.yazi/tmtheme.xml";
              content = builtins.readFile "${kanagawa-dragon}/tmtheme.xml";
            };
          };
        }).wrapper;
    };
}
