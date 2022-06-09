{ config, lib, pkgs, ... }:

{
  imports = [
    ../shared/home-manager.nix
  ];

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = (import ../shared/home-packages.nix) {
    inherit pkgs;
    extras = [
      pkgs.discord-canary
      pkgs.pulumi-bin
      pkgs.spotify
    ];
  };
}
