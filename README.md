# Hyprland Setup

> [!NOTE]
> You need to have minimal desktop installation using `archlinstall`.\
> This script doesn't configure audio, network settings, > etc.\
> You need to configure it during `archinstall`.

So, this is my hyprland rice in archlinux.\
This setup contains minimal configuration to setting up your desktop.\
To install my setup:

- Just make sure to clone the setup in `$HOME` directory.  
- `cd ~/hyprland`.
- Then run `./setup.sh`.

Also, my setup contain a default wallpapers.
To change it just press `SUPER + W`.\
To add your custom wallpapers, just add wallpapers to `~/Pictures/Wallpapers/`, after running `setup.sh`.

## FAQ

### 1. How to change the default browser?

To get the current default web browser:\
`xdg-settings get default-web-browser`\
To set the default web browser:\
`xdg-settings set default-web-browser firefox.desktop`\
Obviously change Firefox to whatever browser you want, and remember that you have to point to the `.desktop` file of the browser.\
For more info, check [xdg-utils](https://man.archlinux.org/man/gsettings.1)
