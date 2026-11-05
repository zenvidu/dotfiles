#!/usr/bin/env bash

# Catppuccin Mocha color palette (color name → hex code)
declare -A colors=(
  [blue]="#89B4FA"
  [palebrown]="#F2CDCD"
  [green]="#A6E3A1"
  [breeze]="#B4BEFE"
  [carmine]="#EBA0AC"
  [violet]="#CBA6F7"
  [orange]="#FAB387"
  [pink]="#F5C2E7"
  [red]="#F38BA8"
  [white]="#F5E0DC"
  [adwaita]="#74C7EC"
  [cyan]="#89DCEB"
  [teal]="#94E2D5"
  [yellow]="#F9E2AF"
)

# Read the HEX color code from a plain text file
hex=$(<~/.config/matugen/papirus-folders/folder-color.txt)

# Function that converts HEX color to RGB
hex_to_rgb() {
  local hex=$1
  local r=$((16#${hex:1:2}))
  local g=$((16#${hex:3:2}))
  local b=$((16#${hex:5:2}))
  echo "$r $g $b"
}

read r1 g1 b1 <<< "$(hex_to_rgb "$hex")"

# Initialize minimum distance and closest color
min_distance=1000000
closest_color=""

for name in "${!colors[@]}"; do
  read r2 g2 b2 <<< "$(hex_to_rgb "${colors[$name]}")"
  distance=$(( (r1 - r2) * (r1 - r2) + (g1 - g2) * (g1 - g2) + (b1 - b2) * (b1 - b2) ))
  if (( distance < min_distance )); then
    min_distance=$distance
    closest_color=$name
  fi
done

#echo "Closest Catppuccin Mocha color to $hex is: $closest_color"
papirus-folders -C $closest_color
