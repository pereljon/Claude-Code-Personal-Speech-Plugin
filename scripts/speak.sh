#!/bin/bash
# Claude Personal Speech — Stop hook entry point
# Reads the last assistant message, strips markdown, and launches speech asynchronously.

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.last_assistant_message')

# Skip if no message
[ -z "$MESSAGE" ] || [ "$MESSAGE" = "null" ] && exit 0

SETTINGS="$PLUGIN_ROOT/speak-settings.json"
MAX_CHARS=$(jq -r '.maxChars' "$SETTINGS")

# Truncate long responses
SHORT=$(echo "$MESSAGE" | head -c "$MAX_CHARS")

# Strip markdown formatting
CLEAN=$(echo "$SHORT" | sed 's/[#*`_\[\]]//g' | sed 's/|//g')

# Skip if nothing left after stripping
[ -z "$(echo "$CLEAN" | tr -d '[:space:]')" ] && exit 0

# Write text to temp file
TMPFILE=$(mktemp /tmp/claude-speak-text.XXXXXX)
echo "$CLEAN" > "$TMPFILE"

# Launch via osascript — creates a truly independent process
# that survives when Claude Code kills the hook's process group
osascript -e "do shell script \"'$PLUGIN_ROOT/scripts/speak-launcher.sh' '$TMPFILE' &> /dev/null &\""
