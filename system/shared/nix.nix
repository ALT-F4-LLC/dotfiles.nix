{ pkgs }: {
  extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
    warn-dirty = false
  '';

  gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  package = pkgs.nixUnstable;

  settings = { auto-optimise-store = true; };
}
