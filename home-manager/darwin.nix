{ config, lib, pkgs, ... }:

{
  home.file."Library/Application Support/k9s/skin.yml".source = ./config/k9s/skin.yml;

  imports = [ ./home-manager.nix ];
}
