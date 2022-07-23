{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    iterm2
    vim
  ];

  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ./users/shared/overlays.nix)
    ];
  };

  programs.zsh.enable = true;

  system.stateVersion = 4;
}
