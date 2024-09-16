#!/bin/bash

echo "Enable hyprland repo"
sudo dnf copr enable solopasha/hyprland

echo "Installing Packages"
sudo dnf install $(grep -vE "^\s*#" ~/hyprland/.scripts/packages.txt | tr "\n" " ")

echo "Linking Directories"

if command -v stow &>/dev/null; then
  stow .
  echo "Hyprland Directories are linked"
else
  sudo dnf install stow
  stow .
  echo "Hyprland Directories are linked"
fi

echo "Clonning my wallpapers"
if [ ! -d "$HOME/Pictures/wall" ]; then
  git clone https://github.com/harshv5094/wall ~/Pictures/
else
  echo "wallpapers directory is already clonned"
fi
