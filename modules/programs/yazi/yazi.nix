{ self, ... }:
{
  perSystem =
    {
      pkgs,
      wrapperPkgs,
      ...
    }:
    let
      kanagawa-dragon = pkgs.fetchFromGitHub {
        owner = "marcosvnmelo";
        repo = "kanagawa-dragon.yazi";
        rev = "b9541e84dc13265548e5bbb12c274b70b381b5cc";
        hash = "sha256-8gtpID6OdvYfRKT0Z2aypDdbBsavCBg2/pcXC7x3vTg=";
      };
      lazygit = pkgs.fetchFromGitHub {
        owner = "Lil-Dank";
        repo = "lazygit.yazi";
        rev = "e73fd74c2af3300368b33da1cfbab6a8649a41a8";
        hash = "sha256-KPvjXjYE0W4Q2xZiVfMwZbtalHt0FbgLtEK4sUWbYOI=";
      };
      # Vendored locally: ripdrag is Linux-only, so drag.yazi needs a macOS
      # branch (copy selection to a temp dir + reveal in Finder). Kept in-repo
      # instead of pinning upstream so the patch is editable here.
      drag = ./plugins/drag.yazi;
    in
    {
      packages.yazi =
        (self.inputs.wrappers.wrappers.yazi.apply {
          pkgs = wrapperPkgs;
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
              {
                on = [
                  "g"
                  "i"
                ];
                run = "plugin lazygit";
                desc = "Run lazygit";
              }
            ];
            theme.flavor.dark = "kanagawa-dragon";
          };
          plugins = {
            inherit drag;
            lazygit = lazygit;
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
