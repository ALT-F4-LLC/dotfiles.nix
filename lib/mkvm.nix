name: { nixpkgs, home-manager, overlays, system, user }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    { nixpkgs.overlays = overlays; }

    ../hardware/${name}.nix
    ../machines/${name}.nix

    ../users/${user}/nixos.nix

    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/${user}/home-manager.nix;
    }
  ];
}
