---
name: speak-config
description: View and edit Claude Personal Speech settings (voice, rate, pitch, volume, maxChars). Use when the user wants to change how Claude speaks.
---

# Claude Personal Speech Configuration

Read the current settings from `${CLAUDE_PLUGIN_ROOT}/speak-settings.json` and display them to the user in a readable format.

## Settings Reference

| Setting | Description | Default | Range |
|---------|-------------|---------|-------|
| `rate` | Speech speed | 0.58 | 0.0–1.0 (0.5 is normal) |
| `pitch` | Voice pitch | 0.9 | 0.5–2.0 (1.0 is normal) |
| `volume` | Speech volume | 1.0 | 0.0–1.0 |
| `voice` | Voice to use | "personal" | "personal" or a voice name (e.g. "Samantha", "Daniel") |
| `fallbackVoice` | Fallback if primary voice unavailable | "Samantha" | Any macOS voice name |
| `maxChars` | Max characters to speak | 500 | Any positive integer |

## When the user wants to change settings

1. Read `${CLAUDE_PLUGIN_ROOT}/speak-settings.json`
2. Use the Edit tool to modify the requested values
3. Confirm the change — settings take effect on the next response (no recompile needed)

## When the user wants to list available voices

Run: `say -v '?'` via Bash to list all installed macOS voices.

For Personal Voice, the user must have set one up in System Settings > Accessibility > Personal Voice, and granted permission when prompted.
