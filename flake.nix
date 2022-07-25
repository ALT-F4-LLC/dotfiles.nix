{
  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, darwin, home-manager, nixpkgs, neovim-nightly }: {
    darwinConfigurations."erikreinert-macbookpro" = darwin.lib.darwinSystem {
      modules = [
        { nixpkgs.overlays = [ neovim-nightly.overlay ]; }

        ./machines/baremetal-darwin.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."erikreinert" =
            import ./home-manager/erikreinert.nix;
        }
      ];

      system = "x86_64-darwin";
    };

    nixosConfigurations."erikreinert-nixos" = nixpkgs.lib.nixosSystem {
      modules = [
        { nixpkgs.overlays = [ neovim-nightly.overlay ]; }

        ./hardware/vmware-intel.nix
        ./machines/vmware-intel.nix
        ./nixos/erikreinert.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."erikreinert" =
            import ./home-manager/erikreinert.nix;
        }
      ];

      system = "x86_64-linux";
    };
  };
}
