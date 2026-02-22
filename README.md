# Claude Code Personal Speech Plugin

A Claude Code plugin that speaks responses aloud using macOS AVSpeechSynthesizer with Personal Voice support.

## Requirements

- macOS on Apple Silicon (arm64)
- `jq` (`brew install jq`)

## Install

```bash
# 1. Clone the repo
git clone https://github.com/pereljon/Claude-Code-Personal-Speech-Plugin.git
cd Claude-Code-Personal-Speech-Plugin

# 2. Add the Stop hook to your Claude Code settings
```

Add the following to `~/.claude/settings.json` (create the file if it doesn't exist):

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/FULL/PATH/TO/Claude-Code-Personal-Speech-Plugin/scripts/speak.sh"
          }
        ]
      }
    ]
  }
}
```

Replace `/FULL/PATH/TO/` with the actual path where you cloned the repo.

If you already have hooks in your settings, add the Stop entry to your existing `"Stop"` array.

## How it works

1. A **Stop hook** fires after every Claude response
2. The hook extracts the response text, strips markdown, and truncates to `maxChars`
3. Speech launches in a **detached process** (via `osascript`) so it doesn't block Claude
4. New responses automatically interrupt any still-playing speech

## Settings

Edit `speak-settings.json` to customize:

```json
{
  "rate": 0.58,
  "pitch": 0.9,
  "volume": 1.0,
  "voice": "personal",
  "fallbackVoice": "Samantha",
  "maxChars": 500
}
```

| Setting | Description | Default |
|---------|-------------|---------|
| `rate` | Speech speed (0.0–1.0) | 0.58 |
| `pitch` | Voice pitch (0.5–2.0) | 0.9 |
| `volume` | Volume (0.0–1.0) | 1.0 |
| `voice` | `"personal"` or a voice name | "personal" |
| `fallbackVoice` | Fallback voice name | "Samantha" |
| `maxChars` | Max characters to speak | 500 |

Changes take effect on the next response — no recompile needed.

## Personal Voice

To use Personal Voice:

1. Set up a Personal Voice in **System Settings > Accessibility > Personal Voice**
2. On first use, macOS will prompt for permission to access your Personal Voice
3. Set `"voice": "personal"` in settings (this is the default)

If Personal Voice isn't available, it falls back to the `fallbackVoice` setting.

## List available voices

```bash
say -v '?'
```

## Development

To recompile the Swift binary from source:

```bash
./install.sh
```

Requires Xcode Command Line Tools (`xcode-select --install`).

## Uninstall

Remove the Stop hook entry from `~/.claude/settings.json`.
