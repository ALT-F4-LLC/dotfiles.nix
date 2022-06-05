{ config, lib, pkgs, ... }:
{
  imports = [
    ../shared/home-manager.nix
  ];

  #---------------------------------------------------------------------
  # Files
  #---------------------------------------------------------------------

  home.file.".aws/config".source = ./config-aws;
  home.file.".config/pip/pip.conf".source = ./config-pip;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = (import ../shared/home-packages.nix) {
    inherit pkgs;
    extras = [
      pkgs.slack
    ];
  };
}
