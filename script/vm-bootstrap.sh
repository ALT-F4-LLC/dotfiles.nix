#!/bin/bash
set -eu pipefail

NIXADDR="192.168.20.132"
NIXPORT="22"

# The block device prefix to use.
#   - sda for SATA/IDE
#   - vda for virtio
NIXBLOCKDEVICE="sda"

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS="-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# bootstrap a brand new VM. The VM should have NixOS ISO on the CD drive
# and just set the password of the root user to "root". This will install
# NixOS. After installing NixOS, you must reboot and set the root password
# for the next step.
#
# NOTE(mitchellh): I'm sure there is a way to do this and bootstrap all
# in one step but when I tried to merge them I got errors. One day.
ssh ${SSH_OPTIONS} -p ${NIXPORT} root@${NIXADDR} " \
  parted /dev/${NIXBLOCKDEVICE} -- mklabel gpt; \
  parted /dev/${NIXBLOCKDEVICE} -- mkpart primary 512MiB -8GiB; \
  parted /dev/${NIXBLOCKDEVICE} -- mkpart primary linux-swap -8GiB 100\%; \
  parted /dev/${NIXBLOCKDEVICE} -- mkpart ESP fat32 1MiB 512MiB; \
  parted /dev/${NIXBLOCKDEVICE} -- set 3 esp on; \
  mkfs.ext4 -L nixos /dev/${NIXBLOCKDEVICE}1; \
  mkswap -L swap /dev/${NIXBLOCKDEVICE}2; \
  mkfs.fat -F 32 -n boot /dev/${NIXBLOCKDEVICE}3; \
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