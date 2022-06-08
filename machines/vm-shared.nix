{ config, pkgs, lib, currentSystem, currentSystemName, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    autoOptimiseStore = true;
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "nixos";

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # setup windowing environment
  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "vmware" ]; # Fixes https://github.com/NixOS/nixpkgs/commit/5157246aa4fdcbef7796ef9914c3a7e630c838ef

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };

    displayManager = { defaultSession = "none+i3"; };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = [ pkgs.i3status pkgs.i3lock pkgs.i3blocks pkgs.rofi ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;

  # Manage fonts. We pull these from a secret directory since most of these
  # fonts require a purchase.
  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };

      enable = true;
    };

    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    dunst
    libnotify
    lxappearance
    niv
    pavucontrol
    vim
    wget
  ];

  environment.pathsToLink = [ "/libexec" ];

  # enable hardware features
  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle";

  # runtime directory size
  services.logind.extraConfig = ''
    RuntimeDirectorySize=20G
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  # enable picom
  services.picom.enable = true;

  # Disable the firewall since we're in a VM and we want to make it
  # easy to visit stuff in here. We only use NAT networking anyways.
  networking.firewall.enable = false;

  # enable dconf
  programs.dconf.enable = true;

  # sound
  sound.enable = true;

  # nfs
  fileSystems."/mnt/nfs/production" = {
    device = "192.168.3.7:/mnt/data";
    fsType = "nfs";
    options = [ "nfsvers=4.2" "noauto" "x-systemd.automount" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
