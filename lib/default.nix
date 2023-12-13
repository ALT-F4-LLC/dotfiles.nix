{ inputs }:

let
  home-manager = import ./shared/home-manager.nix { inherit inputs; };
  home-manager-desktop = import ./nixos/home-manager-desktop.nix;
in
{
  # from: https://github.com/NixOS/nixpkgs/pull/264285/files
  geist-mono = { lib, stdenvNoCC, fetchFromGitHub }:
    stdenvNoCC.mkDerivation
      rec {
        pname = "geist-font";
        version = "1.1.0";

        src = fetchFromGitHub {
          hash = "sha256-V74Co6VlqAxROf5/RZvM9X7avygW7th3YQrlg2d3CYc=";
          owner = "vercel";
          repo = "geist-font";
          rev = version;
        };

        postInstall = ''
          install -Dm444 packages/next/dist/fonts/geist-{mono,sans}/*.woff2 -t $out/share/fonts/woff2
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
            imports = [ (home-manager { inherit git; }) ];
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
              (home-manager { inherit git; })
              (home-manager-desktop { inherit pkgs; })
            ];
          };
        }
      ];
    };
}
