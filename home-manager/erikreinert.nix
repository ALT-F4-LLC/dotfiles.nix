{ config, lib, pkgs, ... }:

{
  imports = [ ./shared ];

  home.packages = (import ./packages.nix) {
    inherit pkgs;

    extras = with pkgs; [ pulumi-bin ]; 
  };
}
