{ config, pkgs, ... }: {
  imports = [ ../nixos/services/networking/twingate.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

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

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };

      enable = true;
    };

    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  };

  environment.systemPackages = with pkgs; [
    curl
    dunst
    libnotify
    lxappearance
    pavucontrol
    wget
  ];

  environment.pathsToLink = [ "/libexec" "/share/zsh" ];

  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle";
  hardware.pulseaudio.support32Bit = true;

  i18n.defaultLocale = "en_US.UTF-8";

  networking.useDHCP = false;
  networking.firewall.enable = false;
  networking.interfaces.ens33.useDHCP = true;
  networking.networkmanager.enable = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      warn-dirty = false
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixUnstable;
    settings = { auto-optimise-store = true; };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  programs.dconf.enable = true;
  programs.geary.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.logind.extraConfig = ''
    RuntimeDirectorySize=20G
  '';

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  services.picom.enable = true;
  services.twingate.enable = true;

  services.xserver = {
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
      autoLogin.enable = true;
      defaultSession = "none+i3";
      lightdm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = [ pkgs.i3status pkgs.i3lock pkgs.i3blocks pkgs.rofi ];
    };
  };

  sound.enable = true;

  system.stateVersion = "21.11";

  time.timeZone = "America/Los_Angeles";

  users.mutableUsers = false;

  virtualisation = {
    docker.enable = true;

    podman = {
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };

    vmware.guest.enable = true;
  };
}
