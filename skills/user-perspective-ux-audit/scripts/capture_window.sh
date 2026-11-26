#!/usr/bin/env bash
# Cross-platform macOS & Linux desktop window enumeration and screenshot helper for UserSpec blind UX auditing.
# Usage:
#   ./capture_window.sh --list
#   ./capture_window.sh --title "MyApp" --out "/tmp/shot1.png"
#   ./capture_window.sh --fullscreen --out "/tmp/full.png"

set -euo pipefail

MODE=""
TITLE=""
WINDOW_ID=""
OUT_FILE=""
DELAY_SEC="0.35"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)
      MODE="list"
      shift
      ;;
    --fullscreen)
      MODE="fullscreen"
      shift
      ;;
    --title)
      MODE="window"
      TITLE="${2:-}"
      shift 2
      ;;
    --id)
      MODE="window"
      WINDOW_ID="${2:-}"
      shift 2
      ;;
    --out)
      OUT_FILE="${2:-}"
      shift 2
      ;;
    --delay)
      DELAY_SEC="${2:-0.35}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

OS_NAME="$(uname -s)"

if [[ "$MODE" == "list" ]]; then
  if [[ "$OS_NAME" == "Darwin" ]]; then
    osascript -e 'tell application "System Events" to get {name, unix id} of (every process whose visible is true)'
  elif command -v wmctrl >/dev/null 2>&1; then
    wmctrl -l -p
  elif command -v xdotool >/dev/null 2>&1; then
    for wid in $(xdotool search --onlyvisible --name ".*" 2>/dev/null || true); do
      printf "%s\t%s\n" "$wid" "$(xdotool getwindowname "$wid" 2>/dev/null || true)"
    done
  else
    echo "Install wmctrl or xdotool on Linux to list windows." >&2
    exit 1
  fi
  exit 0
fi

if [[ -z "$OUT_FILE" ]]; then
  echo "Error: --out <path.png> is required." >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT_FILE")"
sleep "$DELAY_SEC"

if [[ "$MODE" == "fullscreen" ]]; then
  if [[ "$OS_NAME" == "Darwin" ]]; then
    screencapture -x "$OUT_FILE"
  elif command -v grim >/dev/null 2>&1 && [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    grim "$OUT_FILE"
  elif command -v maim >/dev/null 2>&1; then
    maim "$OUT_FILE"
  elif command -v import >/dev/null 2>&1; then
    import -window root "$OUT_FILE"
  else
    echo "No supported screenshot tool found (screencapture, grim, maim, or ImageMagick import)." >&2
    exit 1
  fi
  echo "$OUT_FILE"
  exit 0
fi

if [[ "$MODE" == "window" ]]; then
  if [[ "$OS_NAME" == "Darwin" ]]; then
    if [[ -z "$WINDOW_ID" && -n "$TITLE" ]]; then
      WINDOW_ID="$(osascript -e "tell application \"System Events\" to tell (first process whose name contains \"$TITLE\") to get value of attribute \"AXWindowNumber\" of window 1" 2>/dev/null || true)"
    fi
    if [[ -n "$WINDOW_ID" ]]; then
      screencapture -x -l "$WINDOW_ID" "$OUT_FILE"
    else
      screencapture -x "$OUT_FILE"
    fi
  else
    if [[ -z "$WINDOW_ID" && -n "$TITLE" ]] && command -v xdotool >/dev/null 2>&1; then
      WINDOW_ID="$(xdotool search --onlyvisible --name "$TITLE" | head -n 1 || true)"
      if [[ -n "$WINDOW_ID" ]]; then
        xdotool windowactivate "$WINDOW_ID" 2>/dev/null || true
        sleep "$DELAY_SEC"
      fi
    fi
    if [[ -n "$WINDOW_ID" ]] && command -v maim >/dev/null 2>&1; then
      maim -i "$WINDOW_ID" "$OUT_FILE"
    elif [[ -n "$WINDOW_ID" ]] && command -v import >/dev/null 2>&1; then
      import -window "$WINDOW_ID" "$OUT_FILE"
    elif command -v grim >/dev/null 2>&1 && [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
      grim "$OUT_FILE"
    else
      echo "Unable to capture target window; ensure maim, import (ImageMagick), or grim is installed." >&2
      exit 1
    fi
  fi
  echo "$OUT_FILE"
  exit 0
fi

echo "Specify --list, --fullscreen, --title <name>, or --id <window_id>." >&2
exit 1
