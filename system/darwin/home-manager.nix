{ config, lib, pkgs, ... }: {
  imports = [ ./default.nix ];

  home.file."Library/Application Support/k9s/skin.yml".source =
    ../config/k9s/skin.yml;
}
