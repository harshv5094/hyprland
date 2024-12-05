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
  dir_paths=("hypr" "swaync" "waybar" "rofi" "nwg-look")
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
  if command -v pacman &>/dev/null; then
    printf "\n%b\n" "${CYAN} **Removing Packages** ${RESET}"
    paru -Rs hyprland hyprpaper hyprpicker hypridle hyprlock nwg-look rofi waybar swaync brightnessctl pavucontrol xdg-desktop-portal-hyprland wl-clipboard swaync copyq mate-polkit blueman grimblast-git
  fi
}

checkFolderStatus
packageRemove
