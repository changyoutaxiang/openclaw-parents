# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

### VPS Search Helper

- Script: `bin/vps-brave-search`
- Purpose: run Brave web search through VPS when local network cannot reach Brave API.
- Required env vars:
  - `VPS_HOST`
  - `VPS_USER`
  - `VPS_PASS`
  - `BRAVE_API_KEY`
- Example:
  - `VPS_HOST=... VPS_USER=... VPS_PASS=... BRAVE_API_KEY=... bin/vps-brave-search "site:x.com/elvissun/status/2025920521871716562" 5`

### Google Docs Relay (One-Pass Baseline)

- Always use browser profile: `chrome` (not `custom-relay`).
- Relay port baseline: `18792`.
- Before edits, ensure target Docs tab is attached (extension ON on that exact tab).
- Preflight:
  1) `browser tabs` on `chrome` includes the Docs tab
  2) `browser snapshot` sees Docs toolbar
  3) `gog docs cat <docId>` can read
- If `click+type` cannot reach inner editor ref, use JS fallback via `evaluate` on `docs-texteventtarget-iframe` + `[contenteditable=true]`, then verify with `gog docs cat`.
- Full runbook: `docs/google-docs-relay-one-pass.md`
