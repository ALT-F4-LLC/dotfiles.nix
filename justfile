clean:
  rm -f ./result

darwin command profile: && clean
  darwin-rebuild {{ command }} --flake ".#darwin-{{profile}}"

nixos command profile: && clean
  sudo nixos-rebuild {{ command }} --flake ".#nixos-{{profile}}"

update:
  nix flake update

upkeep:
  sudo nix-store --verify --repair
  sudo nix-store --optimise
  sudo nix-store --gc
