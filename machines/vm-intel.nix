{ config, pkgs, ... }:
{
  imports = [ ./vm-shared.nix ];

  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

  networking.interfaces.ens33.useDHCP = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  virtualisation = {
    docker.enable = true;

    podman = {
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };

    vmware.guest.enable = true;
  };
}
