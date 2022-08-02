{ pkgs, ... }:

let username = "erikreinert";
in {
  fileSystems."/mnt/nfs/production" = {
    device = "192.168.3.7:/mnt/data";
    fsType = "nfs";
    options = [ "nfsvers=4.2" "noauto" "x-systemd.automount" ];
  };

  networking = {
    extraHosts = ''
      192.168.1.32 cluster-endpoint
    '';
    hostName = "${username}-nixos";
  };

  nixpkgs.overlays = [ (import ../home-manager/overlays.nix) ];

  services.xserver.displayManager.autoLogin.user = "${username}";

  users.users.${username} = {
    extraGroups = [ "audio" "docker" "wheel" ];
    hashedPassword = "";
    home = "/home/${username}";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJs7Z5a/QPZPaly3N79Ns4qL73k9XMACmqH8H03gHMXf" # iPad
    ];
    shell = pkgs.zsh;
  };
}
