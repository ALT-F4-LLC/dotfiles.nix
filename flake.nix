{
  description = "Development packages and systems for TheAltF4Stream";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ deploy-rs, flake-parts, self, ... }:
    let
      activate = system: deploy-rs.lib.${system}.activate.nixos;
      systems = import ./system { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
          thealtf4stream-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "TheAltF4Stream";
            src = ./config/nvim;
          };
        };
      };

      flake = {
        deploy = {
          nodes = {
            work-nixos = {
              hostname = "work-nixos.localhost";
              profiles.system.path =
                activate "aarch64-linux" self.nixosConfigurations.work-nixos;
              sshUser = "ereinert";
              user = "root";
            };
          };
        };

        darwinConfigurations = {
          thealtf4stream-darwin = systems.mkDarwin {
            system = "x86_64-darwin";
            username = "erikreinert";
          };

          work-darwin = systems.mkDarwin {
            system = "aarch64-darwin";
            username = "ereinert";
          };
        };

        nixosConfigurations = {
          thealtf4stream-nixos = systems.mkNixOS {
            desktop = true;
            system = "x86_64-linux";
            username = "erikreinert";
          };

          work-nixos = systems.mkNixOS {
            desktop = false;
            system = "aarch64-linux";
            username = "ereinert";
          };
        };
      };
    };
}
