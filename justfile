clean:
  sudo nix-store --verify --repair
  sudo nix-store --optimise
  sudo nix-store --gc

rebuild action profile:
  sudo nixos-rebuild {{action}} --flake .#{{profile}}
  rm -f ./result
