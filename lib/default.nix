{ inputs }:

let
  home-manager-nixos = import ./nixos/home-manager.nix { inherit inputs; };
  home-manager-shared = import ./shared/home-manager.nix { inherit inputs; };
in
{
  geist-mono = { lib, stdenvNoCC, fetchzip }:
    stdenvNoCC.mkDerivation {
      pname = "geist-mono";
      version = "3.1.1";

      src = fetchzip {
        hash = "sha256-GzWly6hGshy8DYZNweejvPymcxQSIU7oGUmZEhreMCM=";
        stripRoot = false;
        url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/GeistMono.zip";
      };

      postInstall = ''
        install -Dm444 *.otf -t $out/share/fonts
      '';
    };

  mkDarwin = { git ? { }, system, username }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      modules = [
        (import ./darwin/configuration.nix { inherit username; })

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = { pkgs, ... }: {
            imports = [
              (home-manager-shared { inherit git; })
            ];
            home.file."Library/Application Support/k9s/skin.yml".source = ../config/k9s/skin.yml;
          };
        }
      ];
    };

  mkNixos = { desktop ? true, git ? { }, hypervisor ? "vmware", system, username }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        (import ./nixos/hardware/${hypervisor}/${system}.nix)
        (import ./nixos/configuration.nix { inherit inputs desktop username; })
        (import ./nixos/configuration-desktop.nix { inherit username; })

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${username}" = { pkgs, ... }: {
            imports = [
              (home-manager-nixos { inherit desktop; })
              (home-manager-shared { inherit git; })
            ];
          };
        }
      ];
    };
}
