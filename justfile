ssh_options := "-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

bootstrap destination:
    ssh {{ssh_options}} {{destination}} " \
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
            nix.package = pkgs.nixUnstable;\n \
            nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
            services.openssh.enable = true;\n \
            services.openssh.passwordAuthentication = true;\n \
            services.openssh.permitRootLogin = \"yes\";\n \
            users.users.root.initialPassword = \"root\";\n \
        ' /mnt/etc/nixos/configuration.nix; \
        nixos-install --no-root-passwd; \
        reboot; \
        "

clean:
    sudo nix-collect-garbage -d

darwin profile command:
    darwin-rebuild {{ command }} --flake ".#{{profile}}-darwin" --show-trace
    rm -rf ./result

nixos profile command:
    sudo nixos-rebuild {{ command }} --flake ".#{{profile}}-nixos"
    rm -rf ./result
