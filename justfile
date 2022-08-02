clean:
  rm -f ./result

macbookpro command profile: && clean
  darwin-rebuild {{ command }} --flake ".#macbookpro-{{profile}}"

vmware command profile: && clean
  sudo nixos-rebuild {{ command }} --flake ".#vmware-{{profile}}"

update:
  nix flake update
