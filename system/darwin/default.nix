{ inputs }:

{ system ? "x86_64-darwin"
, username ? "erikreinert"
}:

inputs.darwin.lib.darwinSystem {
  modules = [
    {
      users.users.${username}.home = "/Users/${username}";
    }

    ./system.nix

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = import ./home-manager.nix {
        inherit inputs;
      };
    }
  ];

  system = system;
}
