{inputs}: let
  daggerMetadata = s:
    {
      "aarch64-darwin" = {
        sha256 = "sha256:1wjy4aapagxvld2y8d4bbz36xl4xy2l8xyf0wfwl0b5ps2wkn55v";
        system = "darwin_arm64";
      };
      "aarch64-linux" = {system = "linux_arm64";};
      "x86_64-darwin" = {system = "darwin_amd64";};
      "x86_64-linux" = {
        sha256 = "sha256:1wjy4aapagxvld2y8d4bbz36xl4xy2l8xyf0wfwl0b5ps2wkn55v";
        system = "linux_amd64";
      };
    }
    .${s}
    or (throw "Unsupported system: ${s}");
  defaultGit = {
    extraConfig.github.user = defaultUsername;
    userEmail = "4638629+erikreinert@users.noreply.github.com";
    userName = "Erik Reinert";
  };
  defaultUsername = "erikreinert";
  homeManagerNixos = import ./nixos/home-manager.nix {inherit inputs;};
  homeManagerShared = import ./shared/home-manager.nix {inherit inputs;};
in {
  dagger = {
    stdenvNoCC,
    system,
  }: let
    metadata = daggerMetadata system;
  in
    stdenvNoCC.mkDerivation rec {
      name = "dagger";
      src = builtins.fetchurl {
        sha256 = metadata.sha256;
        url = "https://github.com/dagger/dagger/releases/download/${version}/dagger_${version}_${metadata.system}.tar.gz";
      };
      unpackPhase = ''
        mkdir -p $out/bin
        tar -xzf $src -C .
        mv dagger $out/bin/dagger
      '';
      version = "v0.9.8";
    };

  geist-mono = {
    lib,
    stdenvNoCC,
    fetchzip,
  }:
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

  mkDarwin = {
    git ? defaultGit,
    username ? defaultUsername,
  }: {system}:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        (import ./darwin/configuration.nix {inherit username;})

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
    hypervisor ? "vmware",
    username ? defaultUsername,
  }: {system}:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        (import ./nixos/hardware/${hypervisor}/${system}.nix)
        (import ./nixos/configuration.nix {inherit inputs desktop username;})
        (import ./nixos/configuration-desktop.nix {inherit username;})

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
      ];
    };
}
