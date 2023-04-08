clean:
    sudo nix-collect-garbage -d

darwin profile command:
    darwin-rebuild {{ command }} --flake ".#darwin-{{profile}}"
    rm -rf ./result

nixos profile command:
    sudo nixos-rebuild {{ command }} --flake ".#nixos-{{profile}}"
    rm -rf ./result

update:
    nix flake update
