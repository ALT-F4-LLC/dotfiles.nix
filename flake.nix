{
  description = "Development packages and systems for TheAltF4Stream";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    thealtf4stream-nvim.inputs.nixpkgs.follows = "nixpkgs";
    thealtf4stream-nvim.url = "github:ALT-F4-LLC/thealtf4stream.nvim";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    let
      mkDarwin = self.lib.mkDarwin { };
      mkNixos = self.lib.mkNixos { };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        darwinConfigurations = {
          aarch64 = mkDarwin { system = "aarch64-darwin"; };
        };

        lib = import ./lib { inherit inputs; };

        nixosConfigurations = {
          x86_64 = mkNixos { system = "x86_64-linux"; };
        };
      };

      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ just ];
          };
        };

        packages = {
          geist-mono = self.lib.geist-mono {
            inherit (pkgs) fetchzip lib stdenvNoCC;
          };
        };
      };
    };
}
