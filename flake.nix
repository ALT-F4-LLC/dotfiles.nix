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
      darwinSystem = import ./configuration/darwin.nix;
      nixosSystem = import ./configuration/nixos.nix;
      overlays = [ neovim-nightly.overlay ];
    in {
      darwinConfigurations."macbookpro-personal" =
        darwinSystem "erikreinert" { inherit darwin home-manager overlays; };

      darwinConfigurations."macbookpro-work" =
        darwinSystem "ereinert" { inherit darwin home-manager overlays; };

      nixosConfigurations."vmware-personal" =
        nixosSystem "erikreinert" { inherit nixpkgs home-manager overlays; };

      nixosConfigurations."vmware-work" =
        nixosSystem "ereinert" { inherit nixpkgs home-manager overlays; };
    };
}
