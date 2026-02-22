# Claude Code Personal Speech Plugin — Status

## Current State

Working. Installed via self-hosted marketplace — no manual configuration needed.

```bash
claude plugin marketplace add pereljon/Claude-Code-Personal-Speech-Plugin
claude plugin install claude-personal-speech
```

The plugin's `hooks/hooks.json` registers the Stop hook automatically on install.

## Architecture

```
speak.sh (Stop hook) → strips markdown, truncates → writes temp file
  → osascript launches speak-launcher.sh (detached process)
    → speak-launcher.sh reads settings, kills previous speech
      → SpeakPersonal.app speaks text via AVSpeechSynthesizer
```

Key design decisions:
- **osascript detach**: Claude Code kills the hook's process group after timeout. `osascript -e "do shell script ..."` is the only reliable way to spawn a process that survives this.
- **Temp file JSON parsing**: `osascript -l JavaScript` reads JSON from a temp file via `NSData.dataWithContentsOfFile`. Template literals and stdin approaches failed on messages containing backticks or dollar signs.
- **Precompiled binary**: The Swift binary ships in the repo. `build.sh` exists for development rebuilds only.
- **Self-hosted marketplace**: The repo root serves as both the marketplace (`/.claude-plugin/marketplace.json`) and contains the plugin (`/plugins/claude-personal-speech/`).

## Known Issues

- **VS Code Claude Notifier extension** rewrites `~/.claude/settings.json` on open/close. The speech hook is registered via the plugin's `hooks/hooks.json`, not settings.json, so it's unaffected.

## Next Steps

- [ ] Consider universal binary (arm64 + x86_64) for Intel Mac support
- [ ] Submit to `claude-plugins-official` for broader discoverability via [submission form](https://clau.de/plugin-directory-submission)
