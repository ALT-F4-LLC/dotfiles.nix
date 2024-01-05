{ inputs }: { desktop }: { pkgs, ... }:

let
  home-manager-desktop = import ./home-manager-desktop.nix { inherit pkgs; };
in
{
  imports = if desktop then [ home-manager-desktop ] else [ ];

  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".config/k9s/skin.yml".source = ../../config/k9s/skin.yml;
  home.packages = pkgs.lib.optionals desktop [ pkgs.jetbrains.datagrip ];

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.gpg.enable = true;

  #---------------------------------------------------------------------
  # services
  #---------------------------------------------------------------------

  services.gpg-agent = {
    defaultCacheTtl = 31536000; # cache keys forever don't get asked for password
    enable = true;
    maxCacheTtl = 31536000;
    pinentryFlavor = "tty";
  };
}
