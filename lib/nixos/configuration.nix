{
  desktop,
  hypervisor,
  inputs,
  store,
  username,
}: {pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  fileSystems =
    {}
    // pkgs.lib.optionalAttrs hypervisor.sharing.enable {
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
    // pkgs.lib.optionalAttrs store.mount.enable {
      "/nix" = {
        device = "/dev/disk/by-label/nix";
        fsType = "ext4";
        neededForBoot = true;
        options = ["noatime"];
      };
    };

  environment = {
    pathsToLink = ["/libexec" "/share/zsh"];
    systemPackages = with pkgs;
      [
        curl
        vim
        wget
        xclip
      ]
      ++ pkgs.lib.optionals desktop [
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

  nix = import ../shared/nix.nix;

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio =
        if desktop
        then true
        else false;
    };
  };

  programs.zsh.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services = {
    dbus = {
      packages = [pkgs.gcr];
    };

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
      extraGroups = ["docker" "wheel"] ++ pkgs.lib.optionals desktop ["audio"];
      hashedPassword = "";
      home = "/home/${username}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEoozwkEkRw4BtbKU8+boF6ixoOiE20cpbi1EXHJqnT3unSF2Jb7nqV+ywVVtRAGMtK5mV8j9smjx0A5/yCJkpNy1hamZC7Xx5WHUWn/M6+Xk6OkHSW9DcCPli+RgiL5ESHVhRJWpC9Vp+afXJBrzXzu1mPcObP9cWiMPCy67pVp1Rh/r7leUdzjAORQFxmynjdh8WleguNU7F1IfaGm4JlSdUxQTSFbJJst03gQSQdHoUxtqvBeEAyj1LhN6t7eY1sDSQpflafoVGYznE3GrPn39qATgT1fCr/ELKRqe+j6d7XEJdcGClcAF23lrZhTiMTkrTortHbi/BGV4jDIzT2OyFrXXjZT8ZBl1z7Bm9h9i0JaVjLdUnGJH8Sc/pBt2PWOM9EOaFuhp8uc2LbjqgCeK1Y/zysbV7U6Qz4ChCMLTm7ccPnXctUc69McLcj5q1Jy28xZOED6biUqg9kSZvLQ84Dlrxy2/MjSwINfFBqEP3AhCRhrmxrtPHBM0BpYHAK7xyJyaHPOXVf0MjhH3jLZ+TKlXbXzNoAvh0jrG6oJnprDCeX9OKPOmsxYZMeuHMswAIh6MAibOlQmDfLGGB5cCCSjc0E05I5hxF1U24neZcg8Yk/kbanoRKwPzJAtR+GVdQ0wJJnTQIpTIi6DVsKniHTC5oA/4biLDd6yPpDw==" # macbookpro-2023
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCozwyCmg3mPDHPn5QgZiqqEA+eyd5qtZTlncvCuz4HzIpNW1MQBwwlh43+0aPG7shr3G2BTfmGaWQB8/xAvJtNzFa2U84giEW7PhtWGtH338favimdNNtnR3qe8ME3XyjAFoiycmKneyZGhcyoOPiuQpTlW8HTmo0hGae0bhfDKexAhActDsFQc5DsOQuIr2RsMxSTWFxQp87LoLrO7KTTdcpOYWX/ZT8JAhyAdqFcQzPvGil5CDOBTNoD67c8gay6H0aOfR6F17gm0izz0W1PUoG7VGN5QDMv/NhVVE08/kF13Kxyj+fR0o6Nku++5CvTuwDJUubrGwjjmEN3kBo+r/TV1qGsq928ev4O3I1wPigZAEeZBfkE7xYYBvTK9IxMoQDFGtIDyjABA/V+prtxJTj2ttR36W72dlK3ofWrV5Et/ABbGocvK3dR4SjLDrQs0jfKWksUGFmB06X/FkbV73RY/+5zJiWqi78qGTuoR1qM0px7QDwJWhqcfgxt2hv4NFjgW4cc7FsuDqexZXj0ipH8OVl1k2smX1VQnsHs1XPO+65XaHAKs/wvA6w9UMAqkrc3Mt2PZ2errspzqxlmBKw+pPbqIeUOyU7/mYX713mON66R7S+iROYOAy5uxmlue0bqkyMvxqmi4LaowwW6hnEnO4LPI7bCNCEPSRn6WQ==" # work
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJs7Z5a/QPZPaly3N79Ns4qL73k9XMACmqH8H03gHMXf" # iPad
      ];
      shell = pkgs.zsh;
    };
  };

  virtualisation = {
    docker = {
      daemon = {
        settings = {
          "experimental" = true;
          "features" = {
            "containerd-snapshotter" = true;
          };
        };
      };
      enable = true;
    };

    vmware.guest.enable =
      if hypervisor.type == "vmware"
      then true
      else false;
  };
}
