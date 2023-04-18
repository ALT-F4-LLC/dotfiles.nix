{ username }:

{ pkgs, ... }:

let
  shared-overlays = import ../shared/overlays.nix;
in
{
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [ "@wheel" ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ shared-overlays ];
  };

  programs = {
    zsh.enable = true;
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  users.users.${username}.home = "/Users/${username}";
}
