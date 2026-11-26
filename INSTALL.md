# Installing UserSpec Across Coding Agents

UserSpec is a pure markdown + helper-script skill (`skills/user-perspective-ux-audit/SKILL.md`). It ships zero compiled binaries, requires no API keys, and works across every major AI coding harness.

---

## 1. Google Antigravity

### Option A: Reference from `.agents/skills.json` (Recommended — single clone, auto-synced)
Clone once anywhere on your machine:

```bash
git clone https://github.com/marksimZ/UserSpec.git ~/UserSpec
```

Then add `skills.json` to your project's `.agents/skills.json` (or globally in `~/.gemini/config/skills.json`):

```json
{
  "entries": [
    {
      "path": "~/UserSpec/skills"
    }
  ]
}
```

### Option B: Project-local copy
Copy `skills/user-perspective-ux-audit` directly into `<your-project>/.agents/skills/user-perspective-ux-audit`.

---

## 2. Claude Code

UserSpec includes `.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`:

```text
/plugin marketplace add marksimZ/UserSpec
/plugin install userspec@userspec
```

Or copy `skills/user-perspective-ux-audit` into `~/.claude/skills/user-perspective-ux-audit` (global) or `.claude/skills/user-perspective-ux-audit` (project).

---

## 3. OpenAI Codex CLI & IDE Extension

UserSpec includes `skills/user-perspective-ux-audit/agents/openai.yaml` display metadata.

**Global user install (macOS / Linux):**
```bash
mkdir -p ~/.agents/skills
git clone https://github.com/marksimZ/UserSpec.git /tmp/UserSpec
cp -R /tmp/UserSpec/skills/user-perspective-ux-audit ~/.agents/skills/user-perspective-ux-audit
```

**Global user install (Windows PowerShell):**
```powershell
New-Item -ItemType Directory -Force -Path "$HOME/.agents/skills" | Out-Null
git clone https://github.com/marksimZ/UserSpec.git "$env:TEMP\UserSpec"
Copy-Item -Recurse -Force "$env:TEMP\UserSpec\skills\user-perspective-ux-audit" "$HOME/.agents/skills/user-perspective-ux-audit"
```

Invoke explicitly in Codex with `$user-perspective-ux-audit`.

---

## 4. Cursor, Windsurf, Cline, Roo Code & GitHub Copilot

- **Skill-capable versions (Cursor Agent Skills / OpenCode / Cline Skills)**: Point your skills directory to `skills/user-perspective-ux-audit`.
- **Rules-file fallback (`AGENTS.md` / `.cursor/rules` / `.github/copilot-instructions.md`)**: Copy [`adapters/AGENTS.md`](adapters/AGENTS.md) into your target project root as `AGENTS.md` (or `.cursor/rules/userspec.mdc`).
