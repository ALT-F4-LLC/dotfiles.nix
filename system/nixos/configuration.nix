{ desktop, username }:

{ pkgs, ... }:

let
  desktop-config = import ./configuration-desktop.nix { inherit username; };
  shared-overlays = import ../shared/overlays.nix;
in
{
  imports = [ ] ++ pkgs.lib.optionals desktop [ desktop-config ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
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
    systemPackages = with pkgs; [
      curl
      k3s
      vim
      wget
      xclip
    ] ++ pkgs.lib.optionals desktop [
      dunst
      libnotify
      lxappearance
      pavucontrol
    ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.enable = false;
    hostName = "${username}-nixos";
    networkmanager.enable = true;
  };

  nix = {
    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [ "@wheel" ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = if desktop then true else false;
    };

    overlays = [ shared-overlays ];
  };

  programs = {
    zsh.enable = true;
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
      settings = {
        passwordAuthentication = false;
        permitRootLogin = "no";
      };
    };
  };

  system.stateVersion = "22.11";

  time.timeZone = "America/Los_Angeles";

  users = {
    mutableUsers = false;
    users."${username}" = {
      extraGroups = [ "docker" "wheel" ] ++ pkgs.lib.optionals desktop [ "audio" ];
      hashedPassword = "";
      home = "/home/${username}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCozwyCmg3mPDHPn5QgZiqqEA+eyd5qtZTlncvCuz4HzIpNW1MQBwwlh43+0aPG7shr3G2BTfmGaWQB8/xAvJtNzFa2U84giEW7PhtWGtH338favimdNNtnR3qe8ME3XyjAFoiycmKneyZGhcyoOPiuQpTlW8HTmo0hGae0bhfDKexAhActDsFQc5DsOQuIr2RsMxSTWFxQp87LoLrO7KTTdcpOYWX/ZT8JAhyAdqFcQzPvGil5CDOBTNoD67c8gay6H0aOfR6F17gm0izz0W1PUoG7VGN5QDMv/NhVVE08/kF13Kxyj+fR0o6Nku++5CvTuwDJUubrGwjjmEN3kBo+r/TV1qGsq928ev4O3I1wPigZAEeZBfkE7xYYBvTK9IxMoQDFGtIDyjABA/V+prtxJTj2ttR36W72dlK3ofWrV5Et/ABbGocvK3dR4SjLDrQs0jfKWksUGFmB06X/FkbV73RY/+5zJiWqi78qGTuoR1qM0px7QDwJWhqcfgxt2hv4NFjgW4cc7FsuDqexZXj0ipH8OVl1k2smX1VQnsHs1XPO+65XaHAKs/wvA6w9UMAqkrc3Mt2PZ2errspzqxlmBKw+pPbqIeUOyU7/mYX713mON66R7S+iROYOAy5uxmlue0bqkyMvxqmi4LaowwW6hnEnO4LPI7bCNCEPSRn6WQ==", # work
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJs7Z5a/QPZPaly3N79Ns4qL73k9XMACmqH8H03gHMXf" # iPad
      ];
      shell = pkgs.zsh;
    };
  };

  virtualisation = {
    containerd = {
      enable = true;
      settings =
        let
          fullCNIPlugins = pkgs.buildEnv {
            name = "full-cni";
            paths = with pkgs; [ cni-plugin-flannel cni-plugins ];
          };
        in
        {
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
