#!/bin/bash
#  _   _                    ____  _             _             
# | | | |_   _ _ __  _ __  / ___|| |_ __ _ _ __| |_ ___ _ __  
# | |_| | | | | '_ \| '__| \___ \| __/ _` | '__| __/ _ \ '__| 
# |  _  | |_| | |_) | |     ___) | || (_| | |  | ||  __/ |    
# |_| |_|\__, | .__/|_|    |____/ \__\__,_|_|   \__\___|_|    
#        |___/|_|                                             
#  
# ----------------------------------------------------- 
# Version 2.5
# ----------------------------------------------------- 

clear
GREEN='\033[0;32m'
NONE='\033[0m'

# ----------------------------------------------------- 
# Functions
# ----------------------------------------------------- 

# Check if package is installed
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Install required packages
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

# isKVM
_isKVM() {
    iskvm=$(sudo dmesg | grep "Hypervisor detected")
    if [[ "$iskvm" =~ "KVM" ]] ;then
        echo 0
    else
        echo 1
    fi
}

# Install Yay
_installYay() {
    if sudo pacman -Qs yay > /dev/null ; then
        echo "yay is already installed!"
    else
        echo "yay is not installed. Will be installed now!"
        _installPackagesPacman "base-devel"
        SCRIPT=$(realpath "$0")
        temp_path=$(dirname "$SCRIPT")
        echo $temp_path
        git clone https://aur.archlinux.org/yay-git.git ~/yay-git
        cd ~/yay-git
        makepkg -si
        cd $temp_path
        echo "yay has been installed successfully."
    fi
}

# Required packages for the installer
installer_packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
    "figlet"
)

echo -e "${GREEN}"
cat <<"EOF"
 _   _                  _                 _ 
| | | |_   _ _ __  _ __| | __ _ _ __   __| |
| |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
|  _  | |_| | |_) | |  | | (_| | | | | (_| |
|_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
       |___/|_|                             

ML4W HYPRLAND STARTER PACKAGE
Version 2.5
EOF
echo -e "${NONE}"

# ----------------------------------------------------- 
# Synchronizing package databases
# ----------------------------------------------------- 
sudo pacman -Sy
echo

# ----------------------------------------------------- 
# Install required packages
# ----------------------------------------------------- 
echo ":: Checking that required packages are installed..."
_installPackagesPacman "${installer_packages[@]}";
echo

# ----------------------------------------------------- 
# Double check rsync
# ----------------------------------------------------- 
if ! command -v rsync &> /dev/null; then
    echo ":: Force rsync installation"
    sudo pacman -S rsync --noconfirm
else
    echo ":: rsync double checked"
fi
echo

# Install Yay
# _installYay

# ----------------------------------------------------- 
# Confirm Start
# ----------------------------------------------------- 
echo -e "${GREEN}"
figlet "Installation"
echo -e "${NONE}"
echo "This script will install the core packages for a Hyperland base configuration:"
echo "hyprland waybar rofi-wayland kitty alacritty dunst dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper hyprlock chromium ttf-font-awesome vim"
echo
echo "IMPORTANT: Backup existing configurations in .config if needed."
echo "This script doesn't officially support NVIDIA GPU. But you can give it a try..."
if gum confirm "DO YOU WANT TO START THE INSTALLATION NOW?" ;then
    echo
    echo ":: Installing Hyprland and additional packages"
    echo
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Installation canceled."
    exit;
fi

# ----------------------------------------------------- 
# Install packages 
# ----------------------------------------------------- 

# PLEASE NOTE: Add more packages at the end of the following command
sudo pacman -S hyprland waybar rofi-wayland kitty alacritty dunst dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper hyprlock chromium ttf-font-awesome vim

# Install yay packages
# PLEASE NOTE: Add more packages at the end of the following command
# yay -S pfetch

# Copy configuration
if gum confirm "DO YOU WANT TO COPY THE PREPARED dotfiles INTO .config? (YOU CAN ALSO DO THIS MANUALLY)" ;then
    rsync -a -I . ~/.config/
    echo
    echo ":: Configuration files successfully copied to ~/.config/"
    echo
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Installation canceled."
    echo "PLEASE NOTE: Open ~/.config/hypr/hyprland.conf to change your keyboard layout (default is us) and your screenresolution (default is preferred) if needed."
    echo "Then reboot your system!"
    exit;
fi

if [ -f ~/.config/hypr/hyprland.conf ] ;then
    
    # Setup keyboard layout
    echo -e "${GREEN}"
    figlet "Keyboard"
    echo -e "${NONE}"
    echo "Please select your keyboard layout. Can be changed later in ~/-config/hypr/hyprland.conf"
    echo "Start typing = Search, RETURN = Confirm, CTRL-C = Cancel"
    echo
    keyboard_layout=$(localectl list-x11-keymap-layouts | gum filter --height 15 --placeholder "Find your keyboard layout...")
    echo
    if [ -z $keyboard_layout ] ;then
        keyboard_layout="us" 
    fi
    SEARCH="kb_layout = us"
    REPLACE="kb_layout = $keyboard_layout"
    sed -i -e "s/$SEARCH/$REPLACE/g" ~/.config/hypr/hyprland.conf
    echo ":: Keyboard layout changed to $keyboard_layout"
    echo

    # Set initial screen resolution
    echo -e "${GREEN}"
    figlet "Monitor"
    echo -e "${NONE}"
    echo "Please select your initial screen resolution. Can be changed later in ~/-config/hypr/hyprland.conf"
    echo
    screenres=$(gum choose --height 15 "1024x768" "1280x720" "1280x800" "1440x900" "1280x1024" "1680x1050" "1280x1440" "1600x1200" "1920x1080" "1920x1200" "2560x1440")
    SEARCH="monitor=,preferred,auto,auto"
    REPLACE="monitor=,$screenres,auto,1"
    sed -i -e "s/$SEARCH/$REPLACE/g" ~/.config/hypr/hyprland.conf    
    echo ":: Initial screen resolution set to $screenres"

    # Set KVM environment variables
    if [ $(_isKVM) == "0" ] ;then
        echo -e "${GREEN}"
        figlet "KVM VM"
        echo -e "${NONE}"
        if gum confirm "Are you running this script in a KVM virtual machine?" ;then
            SEARCH="# env = WLR_NO_HARDWARE_CURSORS"
            REPLACE="env = WLR_NO_HARDWARE_CURSORS"
            sed -i -e "s/$SEARCH/$REPLACE/g" ~/.config/hypr/hyprland.conf

            SEARCH="# env = WLR_RENDERER_ALLOW_SOFTWARE"
            REPLACE="env = WLR_RENDERER_ALLOW_SOFTWARE"
            sed -i -e "s/$SEARCH/$REPLACE/g" ~/.config/hypr/hyprland.conf

            echo ":: Environment settings set for KVM cursor support."
        fi
    fi
fi

echo -e "${GREEN}"
figlet "Done"
echo -e "${NONE}"

echo "Open ~/.config/hypr/hyprland.conf to check your new initial Hyprland configuration."
echo
echo "DONE! Please reboot your system!"