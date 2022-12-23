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
    let
      overlays = [ neovim-nightly.overlay ];
      darwinSystem = username:
        darwin.lib.darwinSystem {
          modules = [
            {
              nixpkgs.overlays = overlays;
              users.users.${username}.home = "/Users/${username}";
            }

            ./configuration/darwin.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" =
                import ./home-manager/darwin.nix;
            }
          ];

          system = "x86_64-darwin";
        };
    in {
      darwinConfigurations = {
        macbookpro-personal = darwinSystem "erikreinert";
        macbookpro-work = darwinSystem "ereinert";
      };

      nixosConfigurations = {
        vmware = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.overlays = overlays; }

            ./configuration/nixos-vmware.nix
            ./configuration/nixos.nix

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
