#!/bin/bash
set -eu pipefail

NIXADDR="192.168.6.9"
NIXPORT="22"
NIXUSER="root"

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS="-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# copy nixos configs
rsync -av -e "ssh ${SSH_OPTIONS} -p ${NIXPORT}" \
  --delete \
  --exclude='vendor/' \
  --exclude='.git/' \
  --exclude='.git-crypt/' \
  --exclude='iso/' \
  --exclude='script/' \
  --exclude='result' \
  --rsync-path="sudo rsync" \
  "$(pwd)/" "${NIXUSER}@${NIXADDR}:/nix-config"

# run the nixos-rebuild switch command.
ssh ${SSH_OPTIONS} -p ${NIXPORT} ${NIXUSER}@${NIXADDR} " \
  sudo nixos-rebuild switch --flake "/nix-config#personal" \
"

# make changes take effect
#ssh ${SSH_OPTIONS} -p ${NIXPORT} ${NIXUSER}@${NIXADDR} " \
#  sudo reboot; \
#"
