clean:
  rm -f ./result

darwin subcommand profile: && clean
  darwin-rebuild {{ subcommand }} --flake ".#{{profile}}"

nixos subcommand profile: && clean
  nixos-rebuild {{ subcommand }} --flake ".#{{profile}}"

update:
  nix flake update

upkeep:
  nix store verify
  nix store repair
  nix store optimise
  nix store gc
