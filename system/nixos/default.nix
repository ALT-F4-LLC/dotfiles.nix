{ inputs }:

{ system ? "x86_64-linux"
, username ? "erikreinert"
}:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    ./hardware-vmware.nix
    ./system.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = import ./home-manager.nix {
        inherit inputs;
      };
    }
  ];
}
