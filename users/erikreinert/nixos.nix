{ pkgs, ... }:

{
  fileSystems."/mnt/nfs/production" = {
    device = "192.168.3.7:/mnt/data";
    fsType = "nfs";
    options = [ "nfsvers=4.2" "noauto" "x-systemd.automount" ];
  };

  networking.extraHosts =
  ''
    192.168.1.32 cluster-endpoint
  '';

  nixpkgs.overlays = [
    (import ../shared/overlays-nvim.nix)
  ];

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "erikreinert";

  users.users.erikreinert = {
    isNormalUser = true;
    home = "/home/erikreinert";
    extraGroups = [ "audio" "docker" "wheel" ];
    hashedPassword = "";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJs7Z5a/QPZPaly3N79Ns4qL73k9XMACmqH8H03gHMXf Erik-Reinert-iPad"
    ];
  };
}
