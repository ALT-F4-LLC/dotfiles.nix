# pulled from https://github.com/Twingate/nixpkgs/blob/87a5f86fb31888f9db6892bfebc4d9b5b9eb132e/nixos/modules/services/networking/twingate.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.twingate;
  twingate = pkgs.callPackage ../../pkgs/applications/networking/twingate { };
in {
  options.services.twingate = {
    enable = mkEnableOption "Twingate Client daemon";
  };

  config = mkIf cfg.enable {
    networking.firewall.checkReversePath = lib.mkDefault false;
    networking.networkmanager.enable = true;

    environment.systemPackages = [ twingate ]; # for the CLI
    systemd.packages = [ twingate ];

    systemd.services.twingate.preStart = ''
      mkdir -p '/etc/twingate'
      cp -r -n ${twingate}/etc/twingate/. /etc/twingate/
    '';

    systemd.services.twingate.wantedBy = [ "multi-user.target" ];
  };
}
