{ lib, config, ... }:
let
  cfg = config.darwin.terminal;
  user = config.system.primaryUser;
  services = ./.;
  dest = "/Users/${user}/Library/Services";
in
{
  options.darwin.terminal = lib.mkOption {
    type = lib.types.str;
    default = "Terminal";
    description = "App name to open for the Run Terminal service";
  };

  config.system.activationScripts.postActivation.text = ''
    echo "installing automator services..."
    mkdir -p "${dest}"
    for workflow in "${services}"/*.workflow; do
      name=$(basename "$workflow")
      if ! diff -rq "$workflow" "${dest}/$name" &>/dev/null 2>&1; then
        rm -rf "${dest}/$name"
        cp -r "$workflow" "${dest}/$name"
        chown -R ${user} "${dest}/$name"
      fi
    done
    plutil -replace actions.0.action.ActionParameters.COMMAND_STRING \
      -string "open -a ${cfg}" \
      "${dest}/Run Terminal.workflow/Contents/document.wflow"
    /System/Library/CoreServices/pbs -update
  '';
}
