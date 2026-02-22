# Claude Code Personal Speech Plugin — Status

## Current State

Working. Speech fires on every Claude Code response via a Stop hook registered in `~/.claude/settings.json`. No external dependencies — only macOS on Apple Silicon.

## Architecture

```
speak.sh (Stop hook) → strips markdown, truncates → writes temp file
  → osascript launches speak-launcher.sh (detached process)
    → speak-launcher.sh reads settings, kills previous speech
      → SpeakPersonal.app speaks text via AVSpeechSynthesizer
```

Key design decisions:
- **osascript detach**: Claude Code kills the hook's process group after timeout. `osascript -e "do shell script ..."` is the only reliable way to spawn a process that survives this.
- **Temp file passing**: JSON parsing uses `osascript -l JavaScript` reading from a temp file via `NSData.dataWithContentsOfFile`. Template literals and stdin approaches failed on messages containing backticks or dollar signs.
- **Precompiled binary**: The Swift binary ships in the repo. `build.sh` exists for development rebuilds only.

## Known Issues

- **VS Code Claude Notifier extension** rewrites `~/.claude/settings.json` on every VS Code open/close cycle. The speech hook survives because it's in a separate Stop array entry from the notifier, but this is fragile.
- **Plugin system**: Claude Code's plugin install (`claude plugin install`) only works with marketplace plugins. Local plugin installs via manual registry edits get cleaned up on restart. The plugin structure (`.claude-plugin/plugin.json`, `hooks/hooks.json`) is ready for marketplace distribution.

## Next Steps

- [ ] Publish to a Claude Code marketplace so users can `claude plugin install claude-personal-speech` instead of manually editing settings.json
- [ ] Option A: Submit to `claude-plugins-official` via [submission form](https://clau.de/plugin-directory-submission)
- [ ] Option B: Create a self-hosted marketplace (GitHub repo with `marketplace.json`)
- [ ] Add a Setup hook that auto-registers the Stop hook on plugin install (eliminates manual settings.json editing)
- [ ] Consider universal binary (arm64 + x86_64) for Intel Mac support
