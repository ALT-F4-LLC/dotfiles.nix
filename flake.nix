{
  description = "Development packages and systems for TheAltF4Stream";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      systems = import ./system { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: { };
      flake = {
        darwinConfigurations = {
          darwin-personal = systems.mkDarwin { };
          darwin-work = systems.mkDarwin {
            system = "aarch64-darwin";
            username = "ereinert";
          };
        };
        nixosConfigurations = {
          nixos-personal = systems.mkNixOS { };
        };
      };
    };
}
