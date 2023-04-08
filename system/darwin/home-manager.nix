{ inputs }:

{ config, lib, pkgs, ... }:

let
  home-manager = import ../shared/home-manager { inherit inputs; };
in
{
  imports = [ home-manager ];

  home.file."Library/Application Support/k9s/skin.yml".source =
    ../../config/k9s/skin.yml;
}
