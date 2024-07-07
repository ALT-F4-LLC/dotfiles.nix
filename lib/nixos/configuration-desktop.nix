{
  hypervisor,
  store,
  username,
}: {
  lib,
  pkgs,
  ...
}: {
  fileSystems =
    {}
    // lib.optionalAttrs hypervisor.sharing.enable {
      "/mnt/hgfs" = {
        device = ".host:/";
        fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
        options = [
          "allow_other"
          "auto_unmount"
          "defaults"
          "gid=1000"
          "uid=1000"
          "umask=22"
        ];
      };
    }
    // lib.optionalAttrs store.mount.enable {
      "/nix" = {
        device = "/dev/disk/by-label/nix";
        fsType = "ext4";
        neededForBoot = true;
        options = ["noatime"];
      };
    };

  hardware = {
    graphics.enable = true;

    pulseaudio = {
      enable = true;
      extraConfig = "unload-module module-suspend-on-idle";
      support32Bit = true;
    };
  };

  programs = {
    dconf.enable = true;
    geary.enable = true;
  };

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = username;
      };
      defaultSession = "none+i3";
    };

    picom.enable = true;

    twingate.enable = pkgs.system == "x86_64-linux";

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "fill";
      };

      displayManager.lightdm.enable = true;

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [i3status i3lock i3blocks];
      };

      xkb.layout = "us";
    };
  };

  sound.enable = true;
}
