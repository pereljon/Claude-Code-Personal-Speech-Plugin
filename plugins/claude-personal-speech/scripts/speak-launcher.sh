#!/bin/bash
# Claude Personal Speech — Detached launcher
# Launched by osascript — runs independently of Claude Code.
# Kills any previous speech, reads settings, and runs the speech binary.

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SETTINGS=$(<"$PLUGIN_ROOT/speak-settings.json")

# Parse JSON field via temp file (safe with backticks, quotes, etc.)
json_field() {
    local tmpjson=$(mktemp /tmp/claude-json.XXXXXX)
    echo "$1" > "$tmpjson"
    osascript -l JavaScript -e "JSON.parse($.NSString.alloc.initWithDataEncoding($.NSData.dataWithContentsOfFile('$tmpjson'), $.NSUTF8StringEncoding).js).$2"
    rm -f "$tmpjson"
}

# Read settings and export as env vars for the Swift binary
export SPEAK_RATE=$(json_field "$SETTINGS" "rate")
export SPEAK_PITCH=$(json_field "$SETTINGS" "pitch")
export SPEAK_VOLUME=$(json_field "$SETTINGS" "volume")
export SPEAK_VOICE=$(json_field "$SETTINGS" "voice")
export SPEAK_FALLBACK=$(json_field "$SETTINGS" "fallbackVoice")

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
