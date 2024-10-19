#!/bin/bash

hyprctl hyprpaper unload all
killall hyprpaper

echo "splash = false" >~/.config/hypr/hyprpaper.conf
echo "ipc = true" >>~/.config/hypr/hyprpaper.conf

wallpaper=$(fd ".png|.jpg|.jpeg|.webp" ~/hyprland/wall/ | shuf -n1)
echo "preload = $wallpaper" >>~/.config/hypr/hyprpaper.conf
echo "wallpaper = ,$wallpaper" >>~/.config/hypr/hyprpaper.conf

hyprpaper &
