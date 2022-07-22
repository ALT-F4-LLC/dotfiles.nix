{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      mkVM = import ./lib/mkvm.nix;
      overlays = [ inputs.neovim-nightly-overlay.overlay ];
    in {
      nixosConfigurations.personal = mkVM "vm-intel" rec {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
        user = "erikreinert";
      };

      nixosConfigurations.work = mkVM "vm-intel" rec {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
        user = "ereinert";
      };
    };
}
