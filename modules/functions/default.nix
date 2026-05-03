{ self, lib, ... }:
let
  envHostname = builtins.getEnv "HOST";
  configuredHostnames =
    (builtins.attrNames (self.darwinConfigurations or { }))
    ++ (builtins.attrNames (self.nixosConfigurations or { }));
  currentHostname =
    if envHostname != "" then
      envHostname
    else if builtins.length configuredHostnames == 1 then
      builtins.head configuredHostnames
    else
      "";
  getHostname =
    hostname:
    let
      selectedHostname = if hostname == { } then currentHostname else hostname;
    in
    if selectedHostname == "" then
      throw "No hostname provided. Pass a hostname string or run with an exported HOST, e.g. HOST=$(hostname -s) nix repl --impure"
    else
      selectedHostname;
  getConfiguration =
    hostname: if isDarwinHost hostname then darwinCfg hostname else nixosCfg hostname;
  isDarwinHost = hostname: self.darwinConfigurations ? ${getHostname hostname};
  darwinCfg = hostname: self.darwinConfigurations.${getHostname hostname}.config;
  nixosCfg = hostname: self.nixosConfigurations.${getHostname hostname}.config;
  mapName = list: lib.unique (map (item: item.name) list);
  fromHomebrewOrEmptyList =
    hostname: attr: if isDarwinHost hostname then (darwinCfg hostname).homebrew.${attr} or [ ] else [ ];
  hostPackages =
    hostname:
    let
      selectedHostname = getHostname hostname;
    in
    (
      if isDarwinHost selectedHostname then (darwinCfg selectedHostname) else (nixosCfg selectedHostname)
    ).environment.systemPackages or [ ];
  hostCasks = hostname: fromHomebrewOrEmptyList (getHostname hostname) "casks";
  hostBrews = hostname: fromHomebrewOrEmptyList (getHostname hostname) "brews";
in
{
  flake.lib = {
    inherit hostPackages hostCasks hostBrews;
    hostProfilePackageNames =
      hostname:
      let
        configuration = getConfiguration hostname;
        selfPackages =
          self.packages.${
            configuration.nixpkgs.hostPlatform.system or configuration.pkgs.stdenv.hostPlatform.system
          };
        systemOutPaths = map toString (configuration.environment.systemPackages or [ ]);
      in
      builtins.filter (
        name:
        let
          packagePath = builtins.tryEval (toString selfPackages.${name});
        in
        packagePath.success && builtins.elem packagePath.value systemOutPaths
      ) (builtins.attrNames selfPackages);
    hostPackageNames = hostname: mapName (hostPackages hostname);
    hostCaskNames = hostname: mapName (hostCasks hostname);
    hostBrewNames = hostname: mapName (hostBrews hostname);
  };
}
