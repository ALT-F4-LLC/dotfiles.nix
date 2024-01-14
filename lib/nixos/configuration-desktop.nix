{ username }:

{ pkgs, ... }:

let
  system = pkgs.system;
in
{
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nix";
    fsType = "ext4";
    neededForBoot = true;
    options = [ "noatime" ];
  };

  hardware = {
    opengl.enable = true;

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
    picom.enable = true;

    twingate.enable = system == "x86_64-linux";

    xserver = {
      enable = true;
      layout = "us";

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "fill";
      };

      displayManager = {
        autoLogin = {
          enable = true;
          user = username;
        };
        defaultSession = "none+i3";
        lightdm.enable = true;
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [ i3status i3lock i3blocks ];
      };
    };
  };

  sound.enable = true;
}
