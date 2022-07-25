{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vim ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      warn-dirty = false
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixUnstable;
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [ (import ../home-manager/overlays.nix) ];
  };

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  system.stateVersion = 4;
}
