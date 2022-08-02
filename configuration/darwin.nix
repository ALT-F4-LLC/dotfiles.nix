username:
{ darwin, home-manager, overlays }:

darwin.lib.darwinSystem {
  modules = [
    { nixpkgs.overlays = overlays; }

    ../machines/baremetal-darwin.nix

    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = import ../home-manager/darwin.nix;
    }
  ];

  system = "x86_64-darwin";
}
