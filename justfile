clean:
  rm -f ./result

switch profile: && clean
  sudo nixos-rebuild switch --flake .#{{profile}}

test profile: && clean
  sudo nixos-rebuild test --flake .#{{profile}}

update profile: && (test profile) (switch profile)
  nix flake update

upkeep:
  sudo nix-store --verify --repair
  sudo nix-store --optimise
  sudo nix-store --gc
