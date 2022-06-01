{ config, pkgs, ... }: {
  imports = [
    ./vm-shared.nix
  ];

  virtualisation.vmware.guest.enable = true;

  # Interface is this on Intel Fusion
  networking.interfaces.ens33.useDHCP = true;
}
