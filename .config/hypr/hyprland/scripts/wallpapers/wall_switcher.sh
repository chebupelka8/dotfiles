$previous = $(pwd)

cd ~/.config/hypr/hyprland/scripts

source ./.venv/bin/activate
python wallpapers/wall_switcher.py
deactivate

cd $previous