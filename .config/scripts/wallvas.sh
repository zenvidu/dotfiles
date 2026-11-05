#!/usr/bin/env bash

set -euo pipefail

WALL_DIR="$HOME/.config/wallpapers/choosen"
#WALL_DIR="$HOME/.config/wallpapers/dark"
WALL_LOCK="$HOME/.cache/wallvas"

CWD="$(pwd)"

cd "$WALL_DIR" || exit

IFS=$'\n'
shopt -s nullglob

wall_list=(*.jpg *.jpeg *.png *.gif)

[ ${#wall_list[@]} -eq 0 ] && {
  notify-send -a "wallvas" "No wallpapers found"
  exit 1
}

SELECTED_WALL=$(for a in "${wall_list[@]}"; do
  printf "%s\0icon\x1f%s\n" "$a" "$a"
done | rofi -theme wallvas -show-icons -dmenu -p "Wallvas")

if [ -n "${SELECTED_WALL:-}" ]; then
  IMAGE="$WALL_DIR/$SELECTED_WALL"

  if [ -f "$IMAGE" ]; then
    notify-send -a "wallvas" "Changing Theme" \
      "Applying wallpaper and updating colors, please wait..."

    awww img --transition-type wipe --transition-angle 30 "$IMAGE"

    if command -v matugen >/dev/null; then
      matugen image --source-color-index 0 "$IMAGE" && swaync-client -rs
    fi

    mkdir -p "$WALL_LOCK"

    # Preserve file extension
    EXT="${IMAGE##*.}"
    CACHE_IMG="$WALL_LOCK/cwall.$EXT"
    LINK_IMG="$WALL_LOCK/cwall"

    # New tab page image for firefox or fox-based browsers
    # Need some manual work first; NOTE_to_self:-[write a tutorial on a pastebin & paste the link here]
    # Get the random value from (browser.newtabpage.activity-stream.newtabWallpapers.customWallpaper.uuid)
    files=("$HOME"/.config/librewolf/librewolf/*.pegasus/wallpaper/library/v1-custom-dark-center-1-9bda05a3-c5f0-4e60-a5d3-8405ae9e81ac)
    BROWSER_IMG="${files[0]}"

    cp "$IMAGE" "$CACHE_IMG"

    (
      case "$CACHE_IMG" in
      *.jpg | *.jpeg)
        # controlled lossy compression
        command -v jpegoptim >/dev/null &&
          jpegoptim --strip-all --max=85 "$CACHE_IMG" >/dev/null 2>&1
        ;;
      *.png)
        # lossless optimization
        #command -v optipng >/dev/null && \
        #optipng -o2 "$CACHE_IMG" >/dev/null 2>&1
        # lossy? optimization
        command -v pngquant >/dev/null &&
          pngquant --quality=75-90 --ext .png --force "$CACHE_IMG" >/dev/null 2>&1
        ;;
      *.gif)
        command -v gifsicle >/dev/null &&
          gifsicle -O2 -b "$CACHE_IMG" >/dev/null 2>&1
        ;;
      esac
    ) &

    ln -nfs "$CACHE_IMG" "$LINK_IMG"
    ln -nfs "$LINK_IMG" "$BROWSER_IMG"

    notify-send -a "wallvas" -r 9997 "Theme Applied" \
      "Wallpaper and theme updated successfully!"
  else
    notify-send -a "wallvas" "Error" "Selected file not found!"
  fi
fi

cd "$CWD" || exit
