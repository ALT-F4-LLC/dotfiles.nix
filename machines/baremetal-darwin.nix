{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vim ];

  nix = {
    package = pkgs.nix;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [ (import ../home-manager/shared/overlays.nix) ];
  };

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  system.stateVersion = 4;
}
