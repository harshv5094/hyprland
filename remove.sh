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
  dir_paths=("hypr" "swaync" "waybar" "wlogout" "wofi")
  printf "%b\n" "${CYAN}Checking folder status${RESET}"
  for folder in "${dir_paths[@]}"; do
    if [ -e "$HOME/.config/$folder" ]; then
      printf "%b\n" "${YELLOW} ***$HOME/.config/$folder exist*** ${RESET}"
      printf "%b\n" "${RED} **Removing the existing $folder directory** ${RESET}"
      rm -rf "$HOME/.config/$folder"
      cmdCheck
    else
      printf "%b\n" "${RED} ***$HOME/.config/$folder does not exist*** ${RESET}"
    fi
  done
}

packageRemove() {
  printf "%b\n" "${RED}***Disabling hyprland copr***${RC}"
  if command -v dnf &>/dev/null; then
    sudo dnf copr disable solopasha/hyprland
    sudo dnf copr disable erikreider/SwayNotificationCenter
    cmdCheck
    packages=$(grep -vE "^\s#" "$HOME/hyprland/packages/dnf.txt" | tr "\n" " ")
    printf "\n%b\n" "${CYAN} **Removing ${RED}${packages}${RESET}${CYAN}** ${RESET}"
    sudo dnf remove $packages
  fi

  if command -v pacman &>/dev/null; then
    packages=$(grep -vE "^\s#" "$HOME/hyprland/packages/pacman.txt" | tr "\n" " ")
    printf "\n%b\n" "${CYAN} **Removing ${RED}${packages}${RESET}${CYAN}** ${RESET}"
    paru -Rs $packages
  fi
}

checkFolderStatus
packageRemove
