ssh_options := "-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

bootstrap destination:
    ssh {{ssh_options}} {{destination}} " \
        parted /dev/vda -- mklabel gpt; \
        parted /dev/vda -- mkpart primary 512MiB -8GiB; \
        parted /dev/vda -- mkpart primary linux-swap -8GiB 100\%; \
        parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB; \
        parted /dev/vda -- set 3 esp on; \
        sleep 1; \
        mkfs.ext4 -L nixos /dev/vda1; \
        mkswap -L swap /dev/vda2; \
        mkfs.fat -F 32 -n boot /dev/vda3; \
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
    darwin-rebuild {{ command }} --flake ".#{{profile}}-darwin"
    rm -rf ./result

nixos profile command:
    sudo nixos-rebuild {{ command }} --flake ".#{{profile}}-nixos"
    rm -rf ./result
