clean:
    sudo nix-collect-garbage -d

macbookpro command profile:
    darwin-rebuild {{ command }} --flake ".#macbookpro-{{profile}}"
    rm -rf ./result

vmware command:
    sudo nixos-rebuild {{ command }} --flake ".#vmware"
    rm -rf ./result

update:
    nix flake update
