{ inputs }:

{ pkgs, ... }:

let
  shared-config = import ../shared/home-manager.nix { inherit inputs; };
  shared-packages = import ../shared/home-manager-packages.nix { inherit pkgs; };
in
{
  imports = [ shared-config ];

  home.file."Library/Application Support/k9s/skin.yml".source = ../../config/k9s/skin.yml;

  home.packages = shared-packages;
}
