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
      pkgs.discord
      pkgs.pulumi
      pkgs.spotify
    ];
  };
}
