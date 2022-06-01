{
  description = "NixOS configs and tools by TheAltF4Stream";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-21.11";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    mkVM = import ./lib/mkvm.nix;

    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];
  in {
    nixosConfigurations.vm-intel = mkVM "vm-intel" rec {
      inherit nixpkgs home-manager overlays;
      system = "x86_64-linux";
      user   = "erikreinert";
    };
  };
}