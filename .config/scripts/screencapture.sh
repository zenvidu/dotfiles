#!/usr/bin/env bash
# Take a screenshot in a number of different ways.
# Any of the case statement options can be passed in as a value.

set -o errexit
set -o pipefail
set -o nounset

MODE="${1:-region}"
OUTPUT_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/screenshots"
OUTPUT_FILE="${OUTPUT_DIR}/ss-$(date +%Y%m%d-%H%M%S).png"

mkdir -p "${OUTPUT_DIR}"

case "${MODE}" in
region)
  hyprcap shot -zN --select region --raw
  ;;
window)
  hyprcap shot -zN --select window:active --raw
  ;;
monitor-focused)
  hyprcap shot -zN --select monitor:active --raw
  ;;
*)
  echo "'${MODE}' is not a supported mode, aborting!" >&2
  exit 1
  ;;
esac | satty --filename - --output-filename "${OUTPUT_FILE}"
