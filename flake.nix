{
  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, darwin, home-manager, neovim-nightly, nixpkgs }:
    let
      overlays = [ neovim-nightly.overlay ];
      darwinSystem = { system, username }:
        darwin.lib.darwinSystem {
          modules = [
            {
              nixpkgs.overlays = overlays;
              users.users.${username}.home = "/Users/${username}";
            }

            ./system/darwin.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" =
                import ./home-manager/darwin.nix;
            }
          ];

          system = system;
        };
    in
    {
      darwinConfigurations = {
        macbookpro-personal = darwinSystem {
          system = "x86_64-darwin";
          username = "erikreinert";
        };

        macbookpro-work = darwinSystem {
          system = "aarch64-darwin";
          username = "ereinert";
        };
      };

      nixosConfigurations = {
        vmware = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.overlays = overlays; }

            ./system/nixos-vmware.nix
            ./system/nixos.nix

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
      };
    };
}
