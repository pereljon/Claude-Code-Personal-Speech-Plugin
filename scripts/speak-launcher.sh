#!/bin/bash
# Claude Personal Speech — Detached launcher
# Launched by osascript — runs independently of Claude Code.
# Kills any previous speech, reads settings, and runs the speech binary.

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SETTINGS=$(<"$PLUGIN_ROOT/speak-settings.json")

# Parse JSON with osascript (no jq dependency)
json_get() { osascript -l JavaScript -e "JSON.parse(\`$1\`).$2"; }

# Read settings and export as env vars for the Swift binary
export SPEAK_RATE=$(json_get "$SETTINGS" "rate")
export SPEAK_PITCH=$(json_get "$SETTINGS" "pitch")
export SPEAK_VOLUME=$(json_get "$SETTINGS" "volume")
export SPEAK_VOICE=$(json_get "$SETTINGS" "voice")
export SPEAK_FALLBACK=$(json_get "$SETTINGS" "fallbackVoice")

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
