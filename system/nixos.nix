{ config, pkgs, ... }:
let
  nix = import ./shared/nix.nix { inherit pkgs; };
  nixpkgs = import ./shared/nixpkgs.nix { enablePulseAudio = true; };
  systemPackages = import ./shared/systemPackages.nix {
    inherit pkgs;
    extraPackages = with pkgs; [
      dunst
      k3s
      libnotify
      lxappearance
      pavucontrol
      xclip
    ];
  };
in {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

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

  fileSystems."/mnt/nfs/production" = {
    device = "192.168.3.7:/mnt/data";
    fsType = "nfs";
    options = [ "nfsvers=4.2" "noauto" "x-systemd.automount" ];
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };
    };

    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  };

  environment = {
    pathsToLink = [ "/libexec" "/share/zsh" ];
    systemPackages = systemPackages;
  };

  hardware = {
    opengl.enable = true;

    pulseaudio = {
      enable = true;
      extraConfig = "unload-module module-suspend-on-idle";
      support32Bit = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.enable = false;
    hostName = "erikreinert-nixos";
    interfaces.ens33.useDHCP = true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  nix = nix;

  nixpkgs = nixpkgs;

  programs = {
    dconf.enable = true;
    geary.enable = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services = {
    k3s = {
      enable = true;
      extraFlags = toString [
        "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
      ];
      role = "server";
    };

    logind.extraConfig = ''
      RuntimeDirectorySize=20G
    '';

    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    picom.enable = true;
    twingate.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [
        "vmware"
      ]; # Fixes https://github.com/NixOS/nixpkgs/commit/5157246aa4fdcbef7796ef9914c3a7e630c838ef

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "fill";
      };

      displayManager = {
        autoLogin = {
          enable = true;
          user = "erikreinert";
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

  system.stateVersion = "22.05";

  time.timeZone = "America/Los_Angeles";

  users = {
    mutableUsers = false;

    users.erikreinert = {
      extraGroups = [ "audio" "docker" "wheel" ];
      hashedPassword = "";
      home = "/home/erikreinert";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJs7Z5a/QPZPaly3N79Ns4qL73k9XMACmqH8H03gHMXf" # iPad
      ];
      shell = pkgs.zsh;
    };
  };

  virtualisation = {
    containerd = {
      enable = true;
      settings = let
        fullCNIPlugins = pkgs.buildEnv {
          name = "full-cni";
          paths = with pkgs; [ cni-plugin-flannel cni-plugins ];
        };
      in {
        plugins."io.containerd.grpc.v1.cri".cni = {
          bin_dir = "${fullCNIPlugins}/bin";
          conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
        };
      };
    };

    docker.enable = true;

    podman = {
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };

    vmware.guest.enable = true;
  };
}
