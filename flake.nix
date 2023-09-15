{
  description = "Development packages and systems for TheAltF4Stream";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
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
      systems = [ "aarch64-darwin" "x86_64-linux" ];
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
    };
}
