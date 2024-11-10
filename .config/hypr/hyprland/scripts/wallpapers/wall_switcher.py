from rofi import Rofi

import pathlib
import os


wallpaper_dir = os.path.join(pathlib.Path.home(), ".config/wallpapers")

names = [wallpaper for wallpaper in sorted(os.listdir(wallpaper_dir))]
paths = [os.path.join(wallpaper_dir, wall) for wall in sorted(os.listdir(wallpaper_dir))]

r = Rofi()
selected = r.select(" 󱝂 Wallpaper ", sorted(names))

if selected and selected != (-1, -1):
    os.system(f"swww img {paths[sum(selected)]} --transition-type simple --transition-fps 144")