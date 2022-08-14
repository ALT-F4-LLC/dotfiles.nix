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
      configDarwin = import ./configuration/darwin;
      configNixos = import ./configuration/nixos;
    in {
      darwinConfigurations = {
        macbookpro-personal =
          configDarwin "erikreinert" { inherit darwin home-manager overlays; };
        macbookpro-work =
          configDarwin "ereinert" { inherit darwin home-manager overlays; };
      };

      nixosConfigurations = {
        vmware-personal =
          configNixos "erikreinert" { inherit nixpkgs home-manager overlays; };
      };
    };
}
