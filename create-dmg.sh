#!/bin/zsh

# Usage:
# Step1: ./create-dmg.sh "AppName"
# Step2: sparkle-sign "AppName" "AppName.dmg"

assert() {
  if ! eval "$1"; then
    echo "Error: $2"
    exit 1
  fi
}

# Check if app name is provided or try to find it in project root
if [ -z "$1" ]; then
  APP_PATH=$(find . -maxdepth 1 -type d -name "*.app" -print | head -n 1)
  assert '[ -n "$APP_PATH" ]' "App name is required and no .app bundle found in project root. Usage: ./create-dmg.sh AppName"
  APP_NAME=$(basename "$APP_PATH" .app)
  echo "Found app: $APP_NAME"
else
  APP_NAME="$1"
  APP_PATH="./$APP_NAME.app"
fi

assert '[ -d "$APP_PATH" ]' "App bundle not found: $APP_PATH"

DMG_NAME="$APP_NAME.dmg"

# Optional second argument: custom source folder for DMG contents.
# Default behavior: create a temporary staging folder that contains only the .app bundle.
TMP_DIR=""
if [ -z "$2" ]; then
  TMP_DIR=$(mktemp -d "./.dmg-staging.XXXXXX")
  cp -R "$APP_PATH" "$TMP_DIR/"
  FOLDER_PATH="$TMP_DIR"
else
  FOLDER_PATH="$2"
fi

cleanup() {
  if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

# Check if DMG already exists in the current directory
if [ -f "$DMG_NAME" ]; then
  echo "Removing existing $DMG_NAME file..."
  rm "$DMG_NAME"
fi

# Run create-dmg with the provided folder path
if create-dmg \
  --volname "$APP_NAME" \
  --window-pos 200 120 \
  --window-size 400 300 \
  --icon-size 100 \
  --icon "$APP_NAME.app" 80 110 \
  --hide-extension "$APP_NAME.app" \
  --app-drop-link 252 110 \
  "$DMG_NAME" \
  "$FOLDER_PATH"; then
  open .
  echo "DMG created successfully."
else
  echo "Failed to create DMG."
  exit 1
fi
