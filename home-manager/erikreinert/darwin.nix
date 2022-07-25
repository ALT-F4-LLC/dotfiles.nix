{ config, lib, pkgs, ... }:

{
  imports = [ ../shared/home-manager.nix ];

  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.packages = (import ../shared/packages.nix) {
    inherit pkgs;

    extras = with pkgs; [ pulumi-bin ];
  };
}
