{ config, lib, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
in {
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

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
  };
}
