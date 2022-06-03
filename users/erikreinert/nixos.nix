{ pkgs, ... }:

{
  users.users.erikreinert = {
    isNormalUser = true;
    home = "/home/erikreinert";
    extraGroups = [ "docker" "wheel" ];
    hashedPassword = "";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ../shared/overlays-nvim.nix)
  ];
}
