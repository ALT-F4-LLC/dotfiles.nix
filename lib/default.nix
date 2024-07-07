{inputs}: let
  defaultGit = {
    extraConfig.github.user = defaultUsername;
    userEmail = "4638629+erikreinert@users.noreply.github.com";
    userName = "Erik Reinert";
  };

  defaultStore = {
    mount.enable = false;
  };

  defaultHypervisor = {
    sharing.enable = false;
    type = "vmware";
  };

  defaultUsername = "erikreinert";

  homeManagerNixos = import ./nixos/home-manager.nix {inherit inputs;};
  homeManagerShared = import ./shared/home-manager.nix {inherit inputs;};
in {
  geist-mono = {
    fetchzip,
    lib,
    stdenvNoCC,
  }:
    stdenvNoCC.mkDerivation rec {
      pname = "geist-mono";
      version = "3.2.1";

      src = fetchzip {
        hash = "sha256-hiFc7y/gRvzCdZKTL85ctWyXVmR0nZnzaFSHpj8PoeE=";
        stripRoot = false;
        url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/GeistMono.zip";
      };

      postInstall = ''
        install -Dm444 *.otf -t $out/share/fonts
      '';
    };

  mkDarwin = {
    git ? defaultGit,
    username ? defaultUsername,
    system,
  }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        {
          nix = import ./shared/nix.nix;
          nixpkgs.config.allowUnfree = true;
          programs.zsh.enable = true;
          services.nix-daemon.enable = true;
          system.stateVersion = 4;
          users.users.${username}.home = "/Users/${username}";
        }

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = {pkgs, ...}: {
            imports = [
              (homeManagerShared {inherit git;})
            ];
            home.file."Library/Application Support/k9s/skin.yml".source = ../config/k9s/skin.yml;
          };
        }
      ];
    };

  mkNixos = {
    desktop ? true,
    git ? defaultGit,
    hypervisor ? defaultHypervisor,
    store ? defaultStore,
    system,
    username ? defaultUsername,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          (import ./nixos/hardware/${hypervisor.type}/${system}.nix)
          (import ./nixos/configuration.nix {inherit hypervisor inputs desktop username;})

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = {pkgs, ...}: {
              imports = [
                (homeManagerNixos {inherit desktop;})
                (homeManagerShared {inherit git;})
              ];
            };
          }
        ]
        ++ inputs.nixpkgs.lib.optionals desktop [
          (import
            ./nixos/configuration-desktop.nix
            {
              inherit hypervisor store username;
            })
        ];
    };
}
