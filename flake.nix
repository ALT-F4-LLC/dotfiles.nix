{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, darwin, home-manager, nixpkgs, ... }@inputs:
    let
      mkVM = import ./lib/mkvm.nix;
      overlays = [ inputs.neovim-nightly-overlay.overlay ];
    in {
      nixosConfigurations.personal = mkVM "vm-intel" rec {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
        user = "erikreinert";
      };

      darwinConfigurations.work = darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
          { nixpkgs.overlays = overlays; }
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.blackglasses = import ./users/ereinert/home-manager.nix;
          }
        ];
        system = "x86_64-darwin";
      };
    };
}
