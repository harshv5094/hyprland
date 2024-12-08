#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

function cmdCheck() {
  if [ $? -eq 0 ]; then
    printf "%b\n" "${GREEN}**SUCCESS**${RESET}"
  else
    printf "%b\n" "${RED}**FAIL**${RESET}"
  fi
}

function cmdExist() {
  command -v $1 &>/dev/null
}

function checkFolderStatus() {
  CONFIG_DIR="$HOME/.config"
  BASE_DIR="$HOME/hyprland/.config/"
  dir_paths=("hypr" "swaync" "rofi" "waybar" "nwg-look")
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

function extractColorScheme() {
  printf "%b\n" "${YELLOW} **Installing Lavanda Sea Dark theme directory** ${RESET}"
  if [ -e "$HOME/Lavanda-gtk-theme/" ]; then
    ~/Lavanda-gtk-theme/install.sh -l -c dark
  else
    git clone https://github.com/vinceliuice/Lavanda-gtk-theme "${HOME}/Lavanda-gtk-theme"
    ~/Lavanda-gtk-theme/install.sh -l -c dark
  fi
}

function settingUpSddm() {
  if cmdExist paru; then
    printf "%b\n" "${YELLOW} **Setting Up SDDM Display Manager** ${RESET}"
    paru -S --noconfirm sddm catppuccin-sddm-theme-mocha
    sudo cp -rf ~/hyprland/sddm.conf /etc
    if cmdExist gdm; then
      sudo systemctl disable gdm.service
    fi
    sudo systemctl enable sddm.service
    cmdCheck
  fi
}

function packageInstall() {
  if cmdExist paru; then
    printf "%b\n" "${CYAN} **Installing Required Packages** ${RESET}"
    paru -S --noconfirm hyprland kitty thunar hyprpaper hyprpicker hypridle hyprlock hyprwall-bin hyprgui-bin rofi nwg-look brightnessctl pavucontrol xdg-desktop-portal-hyprland wl-clipboard copyq swaync mate-polkit blueman waybar papirus-icon-theme otf-font-awesome ttf-jetbrains-mono-nerd playerctl network-manager-applet grimblast-git
  else
    printf "%b\n" "${RED} ** Paru (AUR Helper) is not Installed ** ${RESET}\n ${CYAN} ** Installing Paru ** ${RESET}"
    sudo pacman -S --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/paru.git ~/paru && cd ~/paru && makepkg -si
    packageInstall
  fi
}

function main() {
  checkFolderStatus
  packageInstall
  extractColorScheme
  settingUpSddm
}

main
