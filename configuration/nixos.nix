username:
{ nixpkgs, home-manager, overlays }:

nixpkgs.lib.nixosSystem {
  modules = [
    { nixpkgs.overlays = overlays; }

    ../hardware/vmware-intel.nix
    ../machines/vmware-intel.nix
    ../nixos/${username}.nix

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = import ../home-manager/nixos.nix;
    }
  ];

  system = "x86_64-linux";
}
