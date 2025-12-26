{
  pkgs ? import <nixpkgs> { },
}:
let
  utils = import ./utils.nix;
  variables = import ./variables.nix;
in
with variables // utils { inherit pkgs; };
{
  programs.zsh = {
    enable = true;
    promptInit = ''
      ${mkShellSources (import ./shell/sources.nix)}
      ${mkShellVariables { vars = import ./shell/env.nix; }}
      ${mkShellPath (import ./shell/path.nix { inherit pkgs; })}
      ${mkShellFunctions (import ./shell/functions.nix)}
      ${mkShellVariables {
        vars.PS1 = "'$(_update_prompt)'";
        export = false;
      }}
      ${mkShellZshHooks (import ./shell/zsh_hooks.nix)}
      ${mkShellAliases (import ./shell/aliases.nix)}
      ${mkShellOpts (import ./shell/opts.nix)}
      ${mkShellZstyles (import ./shell/zsh_styles.nix)}
      ${mkShellBindkeys (import ./shell/bindkeys.nix)}
      ${mkShellEvals (import ./shell/evals.nix)}
      ${mkShellZleWidgets (import ./shell/zsh_widgets.nix)}
    '';
  };

  users.users."${user}".shell = pkgs.zsh;
}
