clean:
    nix store optimise --verbose
    nix store gc --verbose

macbookpro command profile:
    darwin-rebuild {{ command }} --flake ".#macbookpro-{{profile}}"
    rm -rf ./result

vmware command:
    sudo nixos-rebuild {{ command }} --flake ".#vmware"
    rm -rf ./result

update:
    nix flake update
