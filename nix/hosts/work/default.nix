{
  inputs,
  lib,
  ...
}: let
  variables = import ./../../modules/shared/variables.nix;

  pkgs = import inputs.nixpkgs {
    system = variables.x86Arch;
    config.allowUnfree = true;
  };

  packages = import ./packages.nix {inherit pkgs inputs;};
in {
  imports = [./hardware-configuration.nix ./../../modules/shared];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "br_abnt2";
    useXkbConfig = true;
  };

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.enable = true;

  services.xserver.xkb.layout = "br";

  services.printing.enable = false;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users = with variables; {
    ${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
    };
  };

  environment.systemPackages = packages.pkgs;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [22];
  networking.firewall.allowedUDPPorts = [22];

  fileSystems = {
    "/" = {
      device = "/dev/nvme0n1p3";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };
  };

  virtualisation.docker.enable = true;
  system.stateVersion = "25.05";
}
