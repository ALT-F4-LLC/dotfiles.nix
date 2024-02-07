{username}: let
  nix = import ../shared/nix.nix;
in {
  nix = nix;
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  users.users.${username}.home = "/Users/${username}";
}
