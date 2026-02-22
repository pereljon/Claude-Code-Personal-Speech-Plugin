#!/bin/bash
# Claude Personal Speech — Detached launcher
# Launched by osascript — runs independently of Claude Code.
# Kills any previous speech, reads settings, and runs the speech binary.

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SETTINGS="$PLUGIN_ROOT/speak-settings.json"

# Read settings and export as env vars for the Swift binary
export SPEAK_RATE=$(jq -r '.rate' "$SETTINGS")
export SPEAK_PITCH=$(jq -r '.pitch' "$SETTINGS")
export SPEAK_VOLUME=$(jq -r '.volume' "$SETTINGS")
export SPEAK_VOICE=$(jq -r '.voice' "$SETTINGS")
export SPEAK_FALLBACK=$(jq -r '.fallbackVoice' "$SETTINGS")

TMPFILE="$1"
PIDFILE="/tmp/claude-speak.pid"
BINARY="$PLUGIN_ROOT/bin/SpeakPersonal.app/Contents/MacOS/speak-personal"

# Kill any previous speech process
if [ -f "$PIDFILE" ]; then
    OLD_PID=$(cat "$PIDFILE")
    kill "$OLD_PID" 2>/dev/null
    wait "$OLD_PID" 2>/dev/null
fi

# Speak
if [ -f "$TMPFILE" ] && [ -x "$BINARY" ]; then
    "$BINARY" "$TMPFILE" &
    echo $! > "$PIDFILE"
    wait $!
    rm -f "$PIDFILE"
fi
