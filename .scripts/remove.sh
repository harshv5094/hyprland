#!/bin/bash

echo "Disable hyprland repo"
sudo dnf copr disable solopasha/hyprland

echo "Removing all packages"
sudo dnf remove $(grep -vE "^\s*#" ~/hyprland/.scripts/packages.txt | tr "\n" " ")

echo "Unlinking Directories"
if command -v stow &>/dev/null; then
  stow -D .
  echo "Hyprland Directories are unlinked"
else
  sudo dnf install stow
  stow -D .
  echo "Hyprland Directories are unlinked"
fi
