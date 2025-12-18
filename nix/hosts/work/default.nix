{
  inputs,
  lib,
  ...
}:
let
  variables = import ./../../modules/shared/variables.nix;

  pkgs = import inputs.nixpkgs {
    system = variables.x86Arch;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    (import ./../../modules/shared { inherit inputs pkgs; })
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "br_abnt2";
    useXkbConfig = true;
  };

  services = {
    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      xkb = {
        extraLayouts.br-custom = {
          symbolsFile = ../../../keyboard/symbols/br-custom;
          languages = [ "pt-br" ];
          description = "Custom keyboard configuration based on the abnt2 layout";
        };

        layout = "br-custom";
      };
    };

    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    printing.enable = false;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    openssh.enable = true;
    blueman.enable = true;
  };

  users.users = with variables; {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
    };
  };

  environment.systemPackages = import ./packages.nix { inherit pkgs inputs; };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
      enableBashCompletion = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      enableLsColors = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 22 ];
  };

  virtualisation.docker.enable = true;
  system.stateVersion = "25.05";
}
