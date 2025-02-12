{inputs}: let
  defaultGit = {
    extraConfig.github.user = defaultUsername;
    userEmail = "4638629+erikreinert@users.noreply.github.com";
    userName = "Erik Reinert";
  };

  defaultHomePath = "/home";

  defaultStore = {
    mount.enable = false;
  };

  defaultHypervisor = {
    sharing.enable = false;
    type = "vmware";
  };

  defaultUsername = "erikreinert";

  homeManagerShared = import ./shared/home-manager.nix {inherit inputs;};
in {
  geist-mono = {
    fetchzip,
    lib,
    stdenvNoCC,
  }:
    stdenvNoCC.mkDerivation rec {
      pname = "geist-mono";
      version = "3.3.0";

      src = fetchzip {
        hash = "sha256-4El6oqFDs3jYLbyQfFgDvGz9oP2s3hZ/hZO13Afah0g=";
        stripRoot = false;
        url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/GeistMono.zip";
      };

      postInstall = ''
        install -Dm444 *.otf -t $out/share/fonts
      '';
    };

  mkDarwin = {
    git ? defaultGit,
    homePath ? defaultHomePath,
    username ? defaultUsername,
    system,
  }: let
    homeDirectory =
      if system == "aarch64-darwin" || system == "x86_64-darwin"
      then "/Users/${username}"
      else "${defaultHomePath}/${username}";
  in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        {
          ids.gids.nixbld = 30000; # note: added for stateVersion 6
          nix = import ./shared/nix.nix;
          nixpkgs.config.allowUnfree = true;
          programs.zsh.enable = true;
          system.stateVersion = 6;
          users.users.${username}.home = "/Users/${username}";
        }

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = {pkgs, ...}: {
            imports = [(homeManagerShared {inherit git homeDirectory username;})];

            home.file."Library/Application Support/k9s/skin.yml".source = ../config/k9s/skin.yml;

            home.sessionVariables = {
              PATH = "/Applications/VMware Fusion.app/Contents/Library:$GOPATH/bin:$HOME/.vorpal/bin:$PATH";
            };
          };
        }
      ];
    };

  mkHomeManager = {
    desktop ? true,
    git ? defaultGit,
    homePath ? defaultHomePath,
    system,
    username ? defaultUsername,
  }: let
    homeDirectory =
      if system == "aarch64-darwin" || system == "x86_64-darwin"
      then "/Users/${username}"
      else "${defaultHomePath}/${username}";
    geist-mono = inputs.self.packages.${system}.geist-mono;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      modules =
        [(homeManagerShared {inherit git homeDirectory username;})]
        ++ (
          if (system == "x86_64-linux" || system == "aarch64-linux")
          then [
            (import ./nixos/home-manager.nix)
            (
              if desktop
              then [(import ./nixos/home-manager-desktop.nix {inherit geist-mono;})]
              else []
            )
          ]
          else []
        );

      pkgs = inputs.nixpkgs.legacyPackages.${system};
    };

  mkNixos = {
    desktop ? true,
    git ? defaultGit,
    hypervisor ? defaultHypervisor,
    store ? defaultStore,
    system,
    username ? defaultUsername,
  }: let
    homeDirectory =
      if system == "aarch64-darwin" || system == "x86_64-darwin"
      then "/Users/${username}"
      else "${defaultHomePath}/${username}";
    geist-mono = inputs.self.packages.${system}.geist-mono;
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          (import ./nixos/hardware/${hypervisor.type}/${system}.nix)
          (import ./nixos/configuration.nix {inherit hypervisor inputs desktop store username;})

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = {pkgs, ...}: {
              imports =
                [(homeManagerShared {inherit git homeDirectory username;})]
                ++ (
                  if desktop
                  then [
                    (import ./nixos/home-manager-desktop.nix {inherit geist-mono;})
                  ]
                  else []
                );

              home.file.".config/k9s/skin.yml".source = ../config/k9s/skin.yml;

              home.sessionVariables = {
                PATH = "$GOPATH/bin:$PATH";
              };

              programs.gpg.enable = true;

              services.gpg-agent = {
                defaultCacheTtl = 31536000; # cache keys forever don't get asked for password
                enable = true;
                maxCacheTtl = 31536000;
                pinentryPackage = pkgs.pinentry-gnome3;
              };
            };
          }
        ]
        ++ inputs.nixpkgs.lib.optionals desktop [
          (import
            ./nixos/configuration-desktop.nix
            {
              inherit geist-mono hypervisor username;
            })
        ];
    };
}
