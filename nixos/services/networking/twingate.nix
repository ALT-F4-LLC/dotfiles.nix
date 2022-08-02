# pulled from https://github.com/Twingate/nixpkgs/pull/1/files/4b514832d73550a6af1fc3e1866759aadd18456f
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

    environment.systemPackages = [ twingate ]; # for the CLI
    systemd.packages = [ twingate ];

    system.activationScripts.twingate = stringAfter [ "etc" ] ''
      mkdir -p '/etc/twingate'

      cp -r -n ${twingate}/etc/twingate/. /etc/twingate/
    '';

    systemd.services.twingate.wantedBy = [ "multi-user.target" ];
  };
}
