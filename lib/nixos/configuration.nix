{ inputs, desktop, username }:

{ pkgs, ... }:

let
  configuration-desktop = import ./configuration-desktop.nix { inherit username; };
  nix = import ../shared/nix.nix;
in
{
  imports = if desktop then [ configuration-desktop ] else [ ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  fonts = {
    fontconfig = {
      defaultFonts.monospace = [ "IntelOne Mono" ];
      enable = true;
    };

    fonts = [ pkgs.intel-one-mono ];
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

  nix = nix;

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = if desktop then true else false;
    };
  };

  programs.zsh.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services = {
    logind.extraConfig = ''
      RuntimeDirectorySize=20G
    '';

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  system.stateVersion = "23.05";

  time.timeZone = "America/Los_Angeles";

  users = {
    mutableUsers = false;
    users."${username}" = {
      extraGroups = [ "docker" "wheel" ] ++ pkgs.lib.optionals desktop [ "audio" ];
      hashedPassword = "";
      home = "/home/${username}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCozwyCmg3mPDHPn5QgZiqqEA+eyd5qtZTlncvCuz4HzIpNW1MQBwwlh43+0aPG7shr3G2BTfmGaWQB8/xAvJtNzFa2U84giEW7PhtWGtH338favimdNNtnR3qe8ME3XyjAFoiycmKneyZGhcyoOPiuQpTlW8HTmo0hGae0bhfDKexAhActDsFQc5DsOQuIr2RsMxSTWFxQp87LoLrO7KTTdcpOYWX/ZT8JAhyAdqFcQzPvGil5CDOBTNoD67c8gay6H0aOfR6F17gm0izz0W1PUoG7VGN5QDMv/NhVVE08/kF13Kxyj+fR0o6Nku++5CvTuwDJUubrGwjjmEN3kBo+r/TV1qGsq928ev4O3I1wPigZAEeZBfkE7xYYBvTK9IxMoQDFGtIDyjABA/V+prtxJTj2ttR36W72dlK3ofWrV5Et/ABbGocvK3dR4SjLDrQs0jfKWksUGFmB06X/FkbV73RY/+5zJiWqi78qGTuoR1qM0px7QDwJWhqcfgxt2hv4NFjgW4cc7FsuDqexZXj0ipH8OVl1k2smX1VQnsHs1XPO+65XaHAKs/wvA6w9UMAqkrc3Mt2PZ2errspzqxlmBKw+pPbqIeUOyU7/mYX713mON66R7S+iROYOAy5uxmlue0bqkyMvxqmi4LaowwW6hnEnO4LPI7bCNCEPSRn6WQ==" # work
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

    podman = {
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };

    vmware.guest.enable = if pkgs.system == "aarch64-linux" then false else true;
  };
}
