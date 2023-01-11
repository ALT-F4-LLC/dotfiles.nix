{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ vim ];

  nix = import ./shared/nix.nix { inherit pkgs; };

  nixpkgs = import ./shared/nixpkgs.nix { enablePulseAudio = false; };

  programs = {
    zsh = import ./shared/zsh.nix;
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;
}
