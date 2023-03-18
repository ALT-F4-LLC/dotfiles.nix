{ pkgs }: {
  extraOptions = ''
    experimental-features = nix-command flakes
    keep-derivations = true
    keep-outputs = true
    trusted-users = erikreinert
    warn-dirty = false
  '';

  gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  package = pkgs.nixUnstable;

  settings = {
    auto-optimise-store = true;
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
