{ config, lib, pkgs, ... }:

{
  home.file."Library/Preferences/k9s/skin.yml".source = ./.config/k9s/skin.yml;

  imports = [ ./home-manager.nix ];
}
