{
  description = "Development environments and packages for TheAltF4Stream";
  
  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs@{ darwin, flake-parts, home-manager, neovim-nightly, nixpkgs, ... }:
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
              home-manager.users."${username}" = import ./home-manager/darwin.nix;
            }
          ];

          system = system;
        };
    in
      flake-parts.lib.mkFlake { inherit inputs; } {
        systems = [ "x86_64-linux" "aarch64-darwin" ];
        perSystem = { config, self', inputs', pkgs, system, ... }: {};
        flake = {
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
                  home-manager.users."erikreinert" = import ./home-manager/nixos.nix;
                }
              ];

              system = "x86_64-linux";
            };
          };
        };
      };
}
