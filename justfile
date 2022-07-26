clean:
  rm -f ./result

darwin command profile: && clean
  darwin-rebuild {{ command }} --flake ".#darwin-{{profile}}"

nixos command profile: && clean
  sudo nixos-rebuild {{ command }} --flake ".#nixos-{{profile}}"

update:
  nix flake update

upkeep:
  nix store verify
  nix store repair
  nix store optimise
  nix store gc
