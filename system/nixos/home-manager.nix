{ desktop, inputs }:

{ pkgs, ... }:

let
  desktop-config = import ./home-manager-desktop.nix { inherit pkgs; };
  shared-config = import ../shared/home-manager { inherit inputs; };
  shared-packages = import ../shared/home-manager/packages.nix { inherit pkgs; };
in
{
  imports = [ shared-config ] ++ pkgs.lib.optionals desktop [ desktop-config ];

  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".config/k9s/skin.yml".source = ../../config/k9s/skin.yml;
  home.packages = shared-packages ++ pkgs.lib.optionals desktop [
    pkgs.jetbrains.datagrip
  ];

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
