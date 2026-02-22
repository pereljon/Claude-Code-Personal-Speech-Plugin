# Claude Code Personal Speech Plugin

Speaks Claude Code responses aloud using macOS AVSpeechSynthesizer with Personal Voice support.

## Requirements

- macOS on Apple Silicon (arm64)
- Claude Code

## Install

```bash
# 1. Register the marketplace (one time)
claude plugin marketplace add pereljon/Claude-Code-Personal-Speech-Plugin

# 2. Install the plugin
claude plugin install claude-personal-speech
```

On first response, macOS may prompt for Personal Voice authorization.

## Settings

Edit `speak-settings.json` in the plugin directory to customize:

| Setting | Description | Default |
|---------|-------------|---------|
| `rate` | Speech speed (0.0–1.0) | 0.58 |
| `pitch` | Voice pitch (0.5–2.0) | 0.9 |
| `volume` | Volume (0.0–1.0) | 1.0 |
| `voice` | `"personal"` or a voice name | "personal" |
| `fallbackVoice` | Fallback voice name | "Samantha" |
| `maxChars` | Max characters to speak | 500 |

Changes take effect on the next response — no recompile needed.

To list available voices: `say -v '?'`

## Personal Voice

1. Set up a Personal Voice in **System Settings > Accessibility > Personal Voice**
2. Set `"voice": "personal"` in settings (this is the default)

If Personal Voice isn't available, it falls back to the `fallbackVoice` setting.

## How it works

1. A **Stop hook** fires after every Claude response
2. The hook extracts the response text, strips markdown, and truncates to `maxChars`
3. Speech launches in a **detached process** (via `osascript`) so it doesn't block Claude
4. New responses automatically interrupt any still-playing speech

## Uninstall

```bash
claude plugin uninstall claude-personal-speech
```
