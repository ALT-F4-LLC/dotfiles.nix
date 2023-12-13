{
  description = "Development packages and systems for TheAltF4Stream";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, self, ... }:
    let
      git = {
        extraConfig.github.user = username;
        userEmail = "4638629+erikreinert@users.noreply.github.com";
        userName = "Erik Reinert";
      };
      username = "erikreinert";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        darwinConfigurations = {
          thealtf4stream = self.lib.mkDarwin {
            inherit git username;
            system = "aarch64-darwin";
          };
        };

        lib = import ./lib { inherit inputs; };

        nixosConfigurations = {
          thealtf4stream = self.lib.mkNixos {
            inherit git username;
            system = "x86_64-linux";
          };
        };
      };

      systems = [ "aarch64-darwin" "x86_64-linux" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ just ];
          };
        };

        packages = {
          geist-mono = self.lib.geist-mono {
            inherit (pkgs) fetchFromGitHub lib stdenvNoCC;
          };

          thealtf4stream-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "TheAltF4Stream";
            src = ./config/nvim;
          };
        };
      };
    };
}
