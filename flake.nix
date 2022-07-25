{
  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, darwin, home-manager, nixpkgs, neovim-nightly }:
    let overlays = [ neovim-nightly.overlay ];
    in {
      darwinConfigurations."darwin-personal" = darwin.lib.darwinSystem {
        modules = [
          { nixpkgs.overlays = overlays; }

          ./machines/baremetal-darwin.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."erikreinert" =
              import ./home-manager/darwin.nix;
          }
        ];

        system = "x86_64-darwin";
      };

      darwinConfigurations."darwin-work" = darwin.lib.darwinSystem {
        modules = [
          { nixpkgs.overlays = overlays; }

          ./machines/baremetal-darwin.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."ereinert" =
              import ./home-manager/darwin.nix;
          }
        ];

        system = "x86_64-darwin";
      };

      nixosConfigurations."nixos-personal" = nixpkgs.lib.nixosSystem {
        modules = [
          { nixpkgs.overlays = overlays; }

          ./hardware/vmware-intel.nix
          ./machines/vmware-intel.nix
          ./nixos/erikreinert.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."erikreinert" =
              import ./home-manager/nixos.nix;
          }
        ];

        system = "x86_64-linux";
      };

      nixosConfigurations."nixos-work" = nixpkgs.lib.nixosSystem {
        modules = [
          { nixpkgs.overlays = overlays; }

          ./hardware/vmware-intel.nix
          ./machines/vmware-intel.nix
          ./nixos/ereinert.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."ereinert" =
              import ./home-manager/nixos.nix;
          }
        ];

        system = "x86_64-linux";
      };
    };
}
