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
      configDarwin = import ./configuration/darwin.nix;
      configNixos = import ./configuration/nixos.nix;
      configParams = { inherit darwin home-manager overlays; };
    in {
      darwinConfigurations = {
        macbookpro-personal = configDarwin "erikreinert" configParams;
        macbookpro-work = configDarwin "ereinert" configParams;
      };

      nixosConfigurations = {
        vmware-personal = configNixos "erikreinert" configParams;
        vmware-work = configNixos "ereinert" configParams;
      };
    };
}
