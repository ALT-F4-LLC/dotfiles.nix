{ config, pkgs, ... }: {
  imports = [
    ./vm-shared.nix
  ];

  virtualisation.docker.enable = true;
  virtualisation.vmware.guest.enable = true;

  # Interface is this on Intel Fusion
  networking.interfaces.ens33.useDHCP = true;
}
