{ config, pkgs, ... }:
let
  nix = import ./shared/nix.nix { inherit pkgs; };
  nixpkgs = import ./shared/nixpkgs.nix { };
  systemPackages = import ./shared/systemPackages.nix { inherit pkgs; };
  zsh = import ./shared/zsh.nix;
in {
  environment.systemPackages = systemPackages;

  nix = nix;

  nixpkgs = nixpkgs;

  programs = { zsh = zsh; };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;
}
