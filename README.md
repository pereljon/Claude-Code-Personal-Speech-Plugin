# Claude Code Personal Speech Plugin

A Claude Code plugin that speaks responses aloud using macOS AVSpeechSynthesizer with Personal Voice support.

## Requirements

- macOS (uses AVSpeechSynthesizer)
- Xcode Command Line Tools (`xcode-select --install`)
- `jq` (`brew install jq`)

## Install

```bash
# Clone or download this directory, then:
cd claude-personal-speech
./install.sh

# Install the plugin
claude plugin install .
```

## Test without installing

```bash
claude --plugin-dir ./claude-personal-speech
```

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

Or use the skill: `/claude-personal-speech:speak-config`

Changes take effect on the next response — no recompile needed.

## Personal Voice

To use Personal Voice:

1. Set up a Personal Voice in **System Settings > Accessibility > Personal Voice**
2. On first use, macOS will prompt for permission to access your Personal Voice
3. Set `"voice": "personal"` in settings (this is the default)

If Personal Voice isn't available, it falls back to the `fallbackVoice` setting.

## Uninstall

```bash
claude plugin uninstall claude-personal-speech
```
