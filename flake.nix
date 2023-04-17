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
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
          thealtf4stream-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "TheAltF4Stream";
            src = ./config/nvim;
          };
        };
      };
      flake = {
        darwinConfigurations = {
          thealtf4stream-darwin = systems.mkDarwin { };
          work-darwin = systems.mkDarwin {
            system = "aarch64-darwin";
            username = "ereinert";
          };
        };
        nixosConfigurations = {
          thealtf4stream-nixos = systems.mkNixOS { };
          work-nixos = systems.mkNixOS {
            desktop = false;
            system = "aarch64-linux";
            username = "ereinert";
          };
        };
      };
    };
}
