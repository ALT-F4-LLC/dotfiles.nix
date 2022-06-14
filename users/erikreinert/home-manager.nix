{ config, lib, pkgs, ... }:

{
  imports = [
    ../shared/home-manager.nix
  ];

  #---------------------------------------------------------------------
  # Files
  #---------------------------------------------------------------------

  home.file.".kube/config".source = ./kubeconfig;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = (import ../shared/home-packages.nix) {
    inherit pkgs;
    extras = [
      pkgs.discord
      pkgs.pulumi-bin
      pkgs.spotify
    ];
  };
}
