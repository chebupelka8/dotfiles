# ML4W Hyprland Starter 2.5

To make your start with Hyprland easy, you can find here a basic installation and configuration script.
The default configuration files are already available in the corresponding folder.
The ML4W Hyprland Starter package is the perfect starting point for your Hyprland customization experiments.

## Requirements

This script requires an Arch Linux based distribution. Tested on Arch Linux, EndeavourOS, Manjaro Linux, Garuda Linux, Arco Linux and more. 

Hyprland does not officially support NVIDIA hardware. But many users have reported a successful installation. Please read: https://wiki.hyprland.org/Nvidia/

## Installation

You can install the Hyprland Starter on real hardware (bare metal) or test it first in a Virtual Machine based on QEMU/KVM with activated 3D acceleration.

Just copy/enter the following command into your terminal.

```
bash <(curl -s "https://gitlab.com/stephan-raabe/hyprland-starter/-/raw/main/setup.sh")
```

Or you clone the repository and start the installation with these commands:

```
# git is required
sudo pacman -S git

# Change into your Downloads directory
cd ~/Downloads

# Clone the packages
git clone --depth 1 https://gitlab.com/stephan-raabe/hyprland-starter.git

# You can also download the files and unzip it into your home folder

# Change into the folder
cd hyprland-starter

# Start the script
./install.sh
```

## Packages

The script will install the following packages:

- Window Manager: hyprland 
- Status Bar: waybar 
- Launcher: rofi-wayland 
- Terminal: alacritty 
- Terminal: kitty #optional
- Notification Service: dunst 
- File Manager: dolphin 
- xdg-desktop-portal-hyprland 
- qt5-wayland 
- qt6-wayland 
- Wallpaper: hyprpaper
- Lock screen: hyprlock
- Icons: ttf-font-awesome

Optionally, you can activate the installation of yay to get access to the AUR.

## Key Bindings

The following custom key bindings are enabled (can be customized in ~/.config/hypr/hyprland.conf)

- <kbd>SUPER</kbd> + <kbd>RETURN</kbd> to start terminal alacritty
- <kbd>SUPER</kbd> + <kbd>Q</kbd> to quit an application
- <kbd>SUPER</kbd> + <kbd>B</kbd> to start browser chromium
- <kbd>SUPER</kbd> + <kbd>M</kbd> to exit Hyprland
- <kbd>SUPER</kbd> + <kbd>E</kbd> to start filemanager dolphin
- <kbd>SUPER</kbd></kbd> + <kbd>CTRL</kbd> + <kbd>RETURN</kbd> to start launcher rofi
- <kbd>SUPER</kbd> + <kbd>T</kbd> to toggle floating
- <kbd>SUPER</kbd> + <kbd>F</kbd> to toggle fullscreen
- <kbd>SUPER</kbd> + <kbd>1-9</kbd> to switch workspaces
- more key bindings in ~/.config/hypr/hyprland.conf

## Create our own installer script

You can customize the script by adding more packages to the installation commands.

```
# Install packages 
# PLEASE NOTE: Add more packages at the end of the following command
sudo pacman -S hyprland waybar rofi-wayland kitty alacritty dunst dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper chromium ttf-font-awesome

# Install yay packages
# PLEASE NOTE: Add more packages at the end of the following command
# yay -S pfetch
```