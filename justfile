bootstrap destination username publickey:
    ssh \
    -o PubkeyAuthentication=no \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    {{destination}} " \
        parted /dev/sda -- mklabel gpt; \
        parted /dev/sda -- mkpart primary 512MiB -8GiB; \
        parted /dev/sda -- mkpart primary linux-swap -8GiB 100\%; \
        parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB; \
        parted /dev/sda -- set 3 esp on; \
        sleep 1; \
        mkfs.ext4 -L nixos /dev/sda1; \
        mkswap -L swap /dev/sda2; \
        mkfs.fat -F 32 -n boot /dev/sda3; \
        sleep 1; \
        mount /dev/disk/by-label/nixos /mnt; \
        mkdir -p /mnt/boot; \
        mount /dev/disk/by-label/boot /mnt/boot; \
        nixos-generate-config --root /mnt; \
        sed --in-place '/system\.stateVersion = .*/a \
            nix.package = pkgs.nixUnstable;\n \
            nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
            security.sudo.enable = true;\n \
            security.sudo.wheelNeedsPassword = false;\n \
            services.openssh.enable = true;\n \
            services.openssh.passwordAuthentication = false;\n \
            services.openssh.permitRootLogin = \"no\";\n \
            users.mutableUsers = false;\n \
            users.users.{{username}}.extraGroups = [ \"wheel\" ];\n \
            users.users.{{username}}.password = \"password\";\n \
            users.users.{{username}}.home = \"/home/{{username}}\";\n \
            users.users.{{username}}.isNormalUser = true;\n \
            users.users.{{username}}.openssh.authorizedKeys.keys = [ \"{{publickey}}\" ];\n \
        ' /mnt/etc/nixos/configuration.nix; \
        nixos-install --no-root-passwd; \
        reboot;"

darwin profile command:
    darwin-rebuild {{ command }} --flake ".#{{profile}}-darwin"
    rm -rf ./result

nixos profile command:
    sudo nixos-rebuild {{ command }} --flake ".#{{profile}}-nixos"
    rm -rf ./result
