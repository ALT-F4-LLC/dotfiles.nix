{ pkgs }:
{
  extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
    warn-dirty = false
  '';

  gc = {
    automatic = true;

    interval = {
      Hour = 24;
    };

    options = "--delete-older-than 7d";
  };

  package = pkgs.nixUnstable;

  settings = {
    auto-optimise-store = true;
  };
}
