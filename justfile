clean:
    rm -f ./result

macbookpro command profile: && clean
    darwin-rebuild {{ command }} --flake ".#macbookpro-{{profile}}"

vmware command: && clean
    sudo nixos-rebuild {{ command }} --flake ".#vmware-personal"

update:
    nix flake update
    niv update
