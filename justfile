_default:
    just --list

build profile:
    nix build --json --no-link --print-build-logs ".#{{ profile }}"

cache-build profile cache_name:
    just build "{{ profile }}" | jq -r '.[].outputs | to_entries[].value' | cachix push {{ cache_name }}

cache-inputs cache_name:
    nix flake archive --json \
      | jq -r '.path,(.inputs|to_entries[].value.path)' \
      | cachix push "{{ cache_name }}"

cache-shell cache_name:
    nix develop --profile "dev-profile" -c true
    cachix push "{{ cache_name }}" "dev-profile"

check:
    nix flake check

darwin-build profile="aarch64":
    just build "darwinConfigurations.{{ profile }}.config.system.build.toplevel"

darwin-switch profile="aarch64":
    darwin-rebuild switch --flake ".#{{ profile }}"

darwin-test profile="aarch64":
    darwin-rebuild check --flake ".#{{ profile }}"

nixos-bootstrap destination username publickey:
    ssh \
    -o PubkeyAuthentication=no \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    {{destination}} " \
        parted /dev/nvme0n1 -- mklabel gpt; \
        parted /dev/nvme0n1 -- mkpart primary 512MiB -8GiB; \
        parted /dev/nvme0n1 -- mkpart primary linux-swap -8GiB 100\%; \
        parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB; \
        parted /dev/nvme0n1 -- set 3 esp on; \
        sleep 1; \
        mkfs.ext4 -L nixos /dev/nvme0n1p1; \
        mkswap -L swap /dev/nvme0n1p2; \
        mkfs.fat -F 32 -n boot /dev/nvme0n1p3; \
        sleep 1; \
        mount /dev/disk/by-label/nixos /mnt; \
        mkdir -p /mnt/boot; \
        mount /dev/disk/by-label/boot /mnt/boot; \
        nixos-generate-config --root /mnt; \
        sed --in-place '/system\.stateVersion = .*/a \
            nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
            security.sudo.enable = true;\n \
            security.sudo.wheelNeedsPassword = false;\n \
            services.openssh.enable = true;\n \
            services.openssh.settings.PasswordAuthentication = false;\n \
            services.openssh.settings.PermitRootLogin = \"no\";\n \
            users.mutableUsers = false;\n \
            users.users.{{username}}.extraGroups = [ \"wheel\" ];\n \
            users.users.{{username}}.initialPassword = \"{{username}}\";\n \
            users.users.{{username}}.home = \"/home/{{username}}\";\n \
            users.users.{{username}}.isNormalUser = true;\n \
            users.users.{{username}}.openssh.authorizedKeys.keys = [ \"{{publickey}}\" ];\n \
        ' /mnt/etc/nixos/configuration.nix; \
        nixos-install --no-root-passwd; \
        reboot;"

nixos-build profile="x86_64":
    just build "nixosConfigurations.{{ profile }}.config.system.build.toplevel"

nixos-test profile="x86_64":
    nixos-rebuild test --flake ".#{{ profile }}"

nixos-switch profile="x86_64":
    nixos-rebuild switch --flake ".#{{ profile }}"

update:
    nix flake update
