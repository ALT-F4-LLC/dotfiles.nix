{ pkgs, ... }:

{
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

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ../shared/overlays-nvim.nix)
  ];
}
