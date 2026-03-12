# OpenClaw Agent Setup — Handoff Context

## SYSTEM OVERVIEW

- **Platform**: OpenClaw 2026.2.26, running locally on macOS (Apple Silicon)
- **Gateway**: ws://127.0.0.1:18789, LaunchAgent installed and running (auto-starts on login)
- **Primary channel**: Slack (Socket Mode), bot connected, `dmPolicy=open`, allowFrom includes `*`
- **Primary model**: openai-codex/gpt-5.3-codex (OAuth)
- **Memory search**: enabled, embedding provider = Google Gemini (GEMINI_API_KEY configured in LaunchAgent and auth-profiles.json)
- **Config file**: ~/.openclaw/openclaw.json
- **Skills directory**: ~/.openclaw/skills/
- **Workspace**: ~/.openclaw/workspace/

---

## INSTALLED SKILLS (8 total)

### 1. `self-improving-agent` ✅ READY
- **Type**: Pure Markdown, no CLI dependency
- **Function**: Captures errors, corrections, and learnings into memory for continuous improvement
- **Usage**: Triggers automatically when agent makes mistakes or user provides corrections; no manual invocation needed
- **Activation**: Always-on

### 2. `summarize` ✅ READY
- **CLI**: `summarize` v0.10.0 at /opt/homebrew/bin/summarize
- **Function**: Summarizes URLs, files (PDF, images, audio), and YouTube videos
- **Usage**: Ask agent to summarize any URL, local file path, or YouTube link
- **Example**: "帮我总结这个 PDF" / "summarize https://..."

### 3. `github` ✅ READY (authenticated)
- **CLI**: `gh` at /opt/homebrew/bin/gh
- **Auth**: Logged in as `changyoutaxiang` on github.com
- **Scopes**: repo, read:org, gist
- **Function**: Manage GitHub issues, PRs, CI/CD runs, repo queries via `gh` CLI
- **Usage**: Ask agent to create PR, list issues, check CI status, etc.

### 4. `agent-browser` ✅ READY
- **CLI**: `agent-browser` at ~/.nvm/versions/node/v24.4.1/bin/agent-browser
- **Browser**: Chromium v145 (Playwright) installed at ~/Library/Caches/ms-playwright/chromium-1208
- **Requires**: node, npm (both present)
- **Function**: Headless browser automation — navigate, click, fill forms, screenshot, scrape, record video
- **Usage**: Ask agent to open URL, interact with web UI, extract data from pages

### 5. `capability-evolver` ✅ READY
- **npm package**: `evolver` v0.3.7 (installed globally, no binary — runs via `node index.js`)
- **Function**: Meta-skill — analyzes agent runtime history, identifies failure patterns, applies self-repairs
- **Modes**: `--review` (recommended, human-in-the-loop), default (auto), `--loop` (continuous)
- **Safety note**: Use `--review` flag to prevent uncontrolled self-modification
- **Config env vars**: EVOLVE_ALLOW_SELF_MODIFY (default false), EVOLVE_STRATEGY (default balanced)

### 6. `gog` ✅ READY (authenticated)
- **CLI**: `gog` v0.9.0 at /opt/homebrew/bin/gog
- **Auth**: OAuth authorized for woonleon69@gmail.com
- **OAuth client credentials**: ~/Library/Application Support/gogcli/credentials.json
- **Authorized services**: Gmail, Calendar, Drive, Docs, Sheets, Contacts/People, Tasks, Chat, Classroom
- **Function**: Full Google Workspace CLI integration
- **Usage**: Ask agent to read/send Gmail, create calendar events, read/write Drive files, update Sheets, etc.

### 7. `obsidian` ✅ READY
- **CLI**: `obsidian-cli` at /opt/homebrew/bin/obsidian-cli
- **Default vault**: "Gemini skill" → /Users/wangdong/Desktop/Gemini skill
- **Other vault**: "唱游" at ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/唱游
- **Requires**: Obsidian app installed, URI handler working
- **Function**: Create, read, search, move, delete notes in Obsidian vaults
- **Usage**: Ask agent to create note, search vault, open a note, add to daily note

### 8. `byterover` ⏸️ DEFERRED
- **CLI**: `brv` v1.8.0 at ~/.nvm/versions/node/v24.4.1/bin/brv (byterover-cli package)
- **Architecture**: Client-server. User must manually run `brv` in a separate terminal to start the local server
- **Status**: CLI installed, NOT initialized. Awaiting project-specific setup.
- **Setup when ready**:
  1. Run `brv` in separate terminal
  2. In brv REPL: `/login` (browser OAuth)
  3. In brv REPL: `/init` (initialize project knowledge tree)
  4. Agent can then use `brv query "..."` and `brv curate "..." -f file`
- **Error handling**: If agent gets "No ByteRover instance is running" → tell user to start `brv` in terminal

---

## AUTHENTICATION SUMMARY

| Service | Account | Status |
|---|---|---|
| OpenAI Codex | wangdong@51talk.com | OAuth, token in auth-profiles.json |
| GitHub | changyoutaxiang | gh keyring |
| Google Workspace (gog) | woonleon69@gmail.com | OAuth refresh token stored |
| ClawHub | @changyoutaxiang | Token stored |
| ByteRover | unknown | Not yet authenticated |

---

## KEY FILE PATHS

- Main config: `~/.openclaw/openclaw.json`
- Agent auth profiles: `~/.openclaw/agents/main/agent/auth-profiles.json`
- LaunchAgent plist: `~/Library/LaunchAgents/ai.openclaw.gateway.plist`
- Gateway logs: `~/.openclaw/logs/gateway.log`, `~/.openclaw/logs/gateway.err.log`
- Skills: `~/.openclaw/skills/<skill-name>/SKILL.md`
- Memory DB: `~/.openclaw/memory/main.sqlite`
- Sessions: `~/.openclaw/agents/main/sessions/sessions.json`

---

## KNOWN ISSUES / NOTES

1. **Slack config**: `dmPolicy=open` requires `allowFrom` to include `"*"` — this is already fixed in config. Do NOT revert.
2. **evolver binary**: The `evolver` npm package has no CLI binary. It runs as `node index.js` from within the skill context. Do not attempt to call it as a shell command.
3. **brv npm package**: The npm package named `brv` (v1.0.1) has no binary. The correct package is `byterover-cli` (v1.8.0) which provides the `brv` binary.
4. **gog OAuth app**: Is in Google Cloud "testing" mode. Only woonleon69@gmail.com is added as test user. If other Google accounts are needed, add them at console.cloud.google.com/auth/clients.
5. **Memory search**: Uses Google Gemini embeddings. GEMINI_API_KEY is set in both LaunchAgent plist EnvironmentVariables AND auth-profiles.json (provider: google, type: apikey).

---

## PENDING / NEXT STEPS

- [ ] byterover: initialize when there is a specific project to attach knowledge tree to
- [ ] Consider adding YouTube Data API or Google Analytics API scope to gog OAuth client for expanded Google ecosystem access
- [ ] Explore automation workflows: Gmail daily digest → Slack, Calendar + Drive meeting prep, Sheets data pipeline

---

*Generated: 2026-02-27 | OpenClaw version: 2026.2.26*
