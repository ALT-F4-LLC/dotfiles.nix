#!/bin/bash
set -eu pipefail

sudo rm -rf "/nix-config"

sudo rsync -av \
  --delete \
  --exclude='vendor/' \
  --exclude='.git/' \
  --exclude='.git-crypt/' \
  --exclude='iso/' \
  --exclude='script/' \
  --exclude='result' \
  --rsync-path="sudo rsync" \
  "$(pwd)/" "/nix-config"

sudo nixos-rebuild test --flake "/nix-config/#hippo"

sudo nixos-rebuild switch --flake "/nix-config/#hippo"
