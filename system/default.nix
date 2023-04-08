{ inputs }: {
  mkDarwin = import ./darwin { inherit inputs; };
  mkNixOS = import ./nixos { inherit inputs; };
}
