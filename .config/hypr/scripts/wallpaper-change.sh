#!/bin/bash

hyprctl hyprpaper unload all
killall hyprpaper

monitors=$(hyprctl monitors -j | jq -r ".[] | .name")

for monitor in $monitors; do
  wallpaper=$(fd ".png|.jpg|.jpeg|.webp" ~/hyprland/wall/ | shuf -n1)
  echo "preload = $wallpaper" >>~/.config/hypr/hyprpaper.conf
  echo "wallpaper = $monitor,$wallpaper" >>~/.config/hypr/hyprpaper.conf
done

echo "splash = false" >~/.config/hypr/hyprpaper.conf
echo "ipc = true" >>~/.config/hypr/hyprpaper.conf

hyprpaper &
