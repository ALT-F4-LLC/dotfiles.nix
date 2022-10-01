username:
{ darwin, home-manager, overlays }:

darwin.lib.darwinSystem {
  modules = [
    {
      nixpkgs.overlays = overlays;
      users.users.${username}.home = "/Users/${username}";
    }

    ./system.nix

    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = import ../../home-manager/darwin.nix;
    }
  ];

  system = "x86_64-darwin";
}
