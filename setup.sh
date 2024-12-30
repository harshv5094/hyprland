#!/bin/bash

# Define Colors for Output
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

# Print success or failure based on the last command
function cmdCheck() {
  if [ $? -eq 0 ]; then
    printf "%b\n" "${GREEN}**SUCCESS**${RESET}"
  else
    printf "%b\n" "${RED}**FAIL**${RESET}"
  fi
}

# Check if a command exists
function cmdExist() {
  command -v $1 &>/dev/null
}

# Install Paru (AUR Helper) if not installed
function installParu() {
  printf "%b\n" "${CYAN}** Installing Paru **${RESET}"
  sudo pacman -S --noconfirm --needed git base-devel
  git clone https://aur.archlinux.org/paru.git /tmp/paru && cd /tmp/paru && makepkg -si
  rm -rf /tmp/paru
}

# Check and create symbolic links for configuration folders
function checkFolderStatus() {
  local CONFIG_DIR="$HOME/.config"
  local BASE_DIR="$HOME/hyprland/.config/"
  local dir_paths=("hypr" "swaync" "rofi" "waybar" "nwg-look")

  printf "%b\n" "${CYAN}Checking folder status${RESET}"

  for folder in "${dir_paths[@]}"; do
    if [ -e "$CONFIG_DIR/$folder" ]; then
      printf "%b\n" "${YELLOW}*** $CONFIG_DIR/$folder exists ***${RESET}"
      printf "%b\n" "${RED}** Removing the existing $folder directory **${RESET}"
      rm -rf "$CONFIG_DIR/$folder"
    else
      printf "%b\n" "${RED}** $CONFIG_DIR/$folder does not exist **${RESET}"
    fi

    printf "%b\n" "${CYAN}* Creating symlink for $folder directory *${RESET}"
    ln -s "$BASE_DIR/$folder" "$CONFIG_DIR"
    cmdCheck
  done
}

# Install and apply a color scheme
function extractColorScheme() {
  local theme_dir="$HOME/Templates/Lavanda-gtk-theme"
  printf "%b\n" "${YELLOW}** Installing Lavanda Sea Dark theme directory **${RESET}"

  if [ -e "$theme_dir" ]; then
    "$theme_dir/install.sh" -l
  else
    git clone https://github.com/vinceliuice/Lavanda-gtk-theme "$theme_dir"
    "$theme_dir/install.sh" -l
  fi
}

# Configure and enable SDDM display manager
function settingUpSddm() {
  if cmdExist paru; then
    printf "%b\n" "${YELLOW}** Setting Up SDDM Display Manager **${RESET}"
    paru -S --noconfirm sddm sddm-theme-tokyo-night-git

    if [ -e /etc/sddm.conf ]; then
      sudo rm -rf /etc/sddm.conf
      sudo cp -rf "$HOME/hyprland/sddm.conf" /etc
    else
      sudo cp -rf "$HOME/hyprland/sddm.conf" /etc
    fi

    if cmdExist gdm; then
      printf "%b\n" "${YELLOW}Disabling GDM service...${RESET}"
      sudo systemctl disable gdm.service
    fi

    printf "%b\n" "${YELLOW}Enabling SDDM service...${RESET}"
    sudo systemctl enable sddm.service
    cmdCheck
  fi
}

# Enable systemd services
function systemdServices() {
  printf "%b\n" "${CYAN}** Enable Systemd Services **${RESET}"

  # Helper function to enable a service
  function enableService() {
    local serviceName="$1"
    printf "%b\n" "${YELLOW}** Enabling ${serviceName} **${RESET}"
    sudo systemctl enable --now "${serviceName}.service"

    if systemctl is-active --quiet "${serviceName}.service"; then
      printf "%b\n" "${GREEN}** ${serviceName} is now active **${RESET}"
    else
      printf "%b\n" "${RED}** Failed to activate ${serviceName} **${RESET}"
    fi
  }

  # List of services to enable
  local services=("bluetooth")

  for service in "${services[@]}"; do
    enableService "$service"
  done
}

# Install required packages using paru
function packageInstall() {
  if cmdExist paru; then
    local packages=$(grep -vE "^\s#" "$HOME/hyprland/packages.txt" | tr "\n" " ")
    printf "%b\n" "${CYAN}** Installing Required Packages **${RESET}"
    paru -S --noconfirm $packages
    cmdCheck

    printf "%b\n" "${CYAN}** Setting up XDG Default Directories **${RESET}"
    xdg-user-dirs-update
    cmdCheck
  else
    installParu
    packageInstall
  fi
}

# Main function to orchestrate the script execution
function main() {
  checkFolderStatus
  packageInstall
  extractColorScheme
  settingUpSddm
  systemdServices
}

main
