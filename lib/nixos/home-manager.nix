{pkgs, ...}: {
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".config/k9s/skin.yml".source = ../../config/k9s/skin.yml;

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
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
