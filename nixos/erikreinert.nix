{ pkgs, ... }:

{
  fileSystems."/mnt/nfs/production" = {
    device = "192.168.3.7:/mnt/data";
    fsType = "nfs";
    options = [ "nfsvers=4.2" "noauto" "x-systemd.automount" ];
  };

  networking = {
    extraHosts = ''
      192.168.1.32 cluster-endpoint
    '';
    hostName = "erikreinert-personal";
  };

  nixpkgs.overlays = [ (import ../home-manager/overlays.nix) ];

  services.xserver.displayManager.autoLogin.user = "erikreinert";

  users.users.erikreinert = {
    extraGroups = [ "audio" "docker" "wheel" ];
    hashedPassword = "";
    home = "/home/erikreinert";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJs7Z5a/QPZPaly3N79Ns4qL73k9XMACmqH8H03gHMXf Erik-Reinert-iPad"
    ];
    shell = pkgs.zsh;
  };
}
