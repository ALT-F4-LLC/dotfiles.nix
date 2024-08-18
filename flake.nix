{
  description = "Development packages and systems for TheAltF4Stream";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    thealtf4stream-nvim.url = "github:ALT-F4-LLC/thealtf4stream.nvim";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        darwinConfigurations = {
          aarch64 = self.lib.mkDarwin {system = "aarch64-darwin";};
          x86_64 = self.lib.mkDarwin {system = "x86_64-darwin";};
        };

        lib = import ./lib {inherit inputs;};

        nixosConfigurations = {
          aarch64 = self.lib.mkNixos {
            desktop = false;
            system = "aarch64-linux";
          };

          x86_64 = self.lib.mkNixos {
            hypervisor.sharing.enable = true;
            hypervisor.type = "vmware";
            store.mount.enable = true;
            system = "x86_64-linux";
          };
        };
      };

      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];

      perSystem = {
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) alejandra callPackage just mkShell;
      in {
        devShells = {
          default = mkShell {
            nativeBuildInputs = [just];
          };
        };

        formatter = alejandra;

        packages = {
          geist-mono = callPackage self.lib.geist-mono {};
        };
      };
    };
}
