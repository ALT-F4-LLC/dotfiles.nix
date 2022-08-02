{ pkgs, ... }:

let 
  username = "ereinert";
in
{
  networking.hostName = "${username}-nixos";

  nixpkgs.overlays = [ (import ../home-manager/overlays.nix) ];

  services.xserver.displayManager.autoLogin.user = ${username};

  users.users.${username} = {
    extraGroups = [ "audio" "docker" "wheel" ];
    hashedPassword = "";
    home = "/home/${username}";
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
