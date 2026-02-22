#!/bin/bash
# Claude Personal Speech — Build Script
# Recompiles the Swift speech binary into a macOS app bundle.

set -e

PLUGIN_ROOT="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$PLUGIN_ROOT/bin/SpeakPersonal.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
SOURCE="$PLUGIN_ROOT/scripts/speak-personal.swift"

echo "Claude Personal Speech — Building..."

# Check for swiftc
if ! command -v swiftc &> /dev/null; then
    echo "Error: swiftc not found. Install Xcode or Xcode Command Line Tools:"
    echo "  xcode-select --install"
    exit 1
fi

# Create app bundle structure
echo "Creating app bundle..."
mkdir -p "$MACOS_DIR"

# Write Info.plist
cat > "$CONTENTS_DIR/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>speak-personal</string>
    <key>CFBundleIdentifier</key>
    <string>com.claude.speak-personal</string>
    <key>CFBundleName</key>
    <string>SpeakPersonal</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>LSBackgroundOnly</key>
    <true/>
    <key>NSPersonalVoiceUsageDescription</key>
    <string>Claude Code uses your Personal Voice to speak responses aloud.</string>
</dict>
</plist>
PLIST

# Compile Swift binary
echo "Compiling speak-personal..."
swiftc -O -o "$MACOS_DIR/speak-personal" "$SOURCE" \
    -framework AVFoundation \
    -framework Foundation

chmod +x "$MACOS_DIR/speak-personal"

echo ""
echo "Done! SpeakPersonal.app built at:"
echo "  $APP_DIR"
echo "Done!"
