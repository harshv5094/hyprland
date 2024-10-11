#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

cmdCheck() {
  if [ $? -eq 0 ]; then
    printf "%b\n" "${GREEN}**SUCCESS**${RESET}"
  else
    printf "%b\n" "${RED}**FAIL**${RESET}"
  fi
}

checkFolderStatus() {
  CONFIG_DIR="$HOME/.config"
  BASE_DIR="$HOME/hyprland/.config/"
  dir_paths=("hypr" "swaync" "wofi" "waypaper" "waybar" "wlogout")
  printf "%b\n" "${CYAN}Checking folder status${RESET}"
  for folder in "${dir_paths[@]}"; do
    if [ -e "$HOME/.config/$folder" ]; then
      printf "%b\n" "${YELLOW} ***$HOME/.config/$folder exist*** ${RESET}"
      printf "%b\n" "${RED} **Removing the existing $folder directory** ${RESET}"
      rm -rf "$HOME/.config/$folder"
      printf "%b\n" "${CYAN} *Creating symlink for $folder directory* ${RESET}"
      ln -s "$BASE_DIR/$folder" "$CONFIG_DIR"
      cmdCheck
    else
      printf "%b\n" "${RED} **$HOME/.config/$folder does not exist** ${RESET}"
      printf "%b\n" "${CYAN} *Creating symlink for $folder directory* ${RESET}"
      ln -s "$BASE_DIR/$folder" "$CONFIG_DIR"
      cmdCheck
    fi
  done
}

packageInstall() {
  if command -v dnf &>/dev/null; then
    printf "%b\n" "${CYAN}***Enabling hyprland copr***${RC}"
    sudo dnf copr enable solopasha/hyprland
    sudo dnf copr enable erikreider/SwayNotificationCenter
    cmdCheck
    packages=$(grep -vE "^\s#" "$HOME/hyprland/packages/dnf.txt" | tr "\n" " ")
    printf "\n%b\n" "${CYAN} **Installing ${RED}$packages${RESET}${CYAN}** ${RESET}"
    sudo dnf install $packages
  fi

  if command -v pacman &>/dev/null; then
    packages=$(grep -vE "^\s#" "$HOME/hyprland/packages/pacman.txt" | tr "\n" " ")
    printf "\n%b\n" "${CYAN} **Installing ${RED}$packages wlogout${RESET}${CYAN}** ${RESET}"
    sudo pacman -S $packages
    yay -S wlogout
  fi
}

checkFolderStatus
packageInstall
