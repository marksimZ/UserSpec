<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-dark.png">
    <img src="assets/logo.png" width="210" alt="Specs — the zero-context first-time user">
  </picture>
</p>

<h1 align="center">UserSpec</h1>

<p align="center">
  <em>Didn't read your README. Gives you five seconds. Never hits F5 for you.</em>
</p>

<p align="center">
  <a href="https://github.com/marksimZ/UserSpec/stargazers"><img src="https://img.shields.io/github/stars/marksimZ/UserSpec?style=flat-square&color=111111&label=stars" alt="Stars"></a>
  <img src="https://img.shields.io/badge/modes-lite%20%C2%B7%20full%20%C2%B7%20savage-111111?style=flat-square" alt="Modes: lite, full, savage">
  <img src="https://img.shields.io/badge/surfaces-Web%20%C2%B7%20Mobile%20H5%20%C2%B7%20Desktop-111111?style=flat-square" alt="Surfaces: Web, Mobile H5, Desktop">
  <img src="https://img.shields.io/badge/works%20with-Antigravity%20%C2%B7%20Claude%20%C2%B7%20Codex%20%C2%B7%20Cursor-111111?style=flat-square" alt="Compatible agents">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-111111?style=flat-square" alt="MIT License"></a>
</p>

<p align="center">
  <sub><strong>English</strong> &middot; <a href="README.zh-CN.md">简体中文</a> &middot; <a href="INSTALL.md">Install Guide</a></sub>
</p>

---

You know him. Oversized round specs. Coffee still warm. Thirty other browser tabs open.

He has no idea what your project codename stands for, didn't read your `README.md`, doesn't know the settings gear is hidden inside the footer avatar, and definitely won't press `F5` when your dashboard badge forgets to update after creating an item. Give him five seconds on your landing screen: if he has to squint, guess, or read `STATUS_PENDING`, he closes the tab.

**UserSpec puts him inside your AI agent.**

---

## Why AI UX reviews fail without UserSpec

When you ask a normal coding agent to *"review my app's UI/UX from a user's perspective,"* the first thing it does is read `README.md`, `package.json`, and `src/routes.tsx`. **The test is already ruined.** Once an LLM reads your source code, it suffers from the exact same curse of knowledge you do:

| What a code-spoiled AI says | What **Specs** (blind first-time user) sees |
| :--- | :--- |
| *"Clean minimalist workspace dashboard!"* | *"There are four buttons in the same shade of blue and an empty white table saying `No Data`. What does this app even do?"* |
| *"Status column renders task state properly."* | *"Why does a human-facing table say `TASK_IN_PROGRESS` and `2026-11-26T02:55:28.000Z`?"* |
| *"Created a record; state updates on reload."* | *"I added an item in the modal, went back to Home, and the counter still says `0`. Your app looks broken."* |
| *"Login page works as expected."* | *"You're demanding my email and password before telling me a single sentence about what I'm signing up for."* |

---

## How it works

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/workflow-dark.svg">
    <img src="assets/workflow-light.svg" width="900" alt="UserSpec Zero-Spoiler Wall and Two-Stage Hard Gate Workflow">
  </picture>
</p>

UserSpec enforces **physical role quarantine** and a **hard two-stage gate**:

1. **The Zero-Spoiler Wall (Coordinator vs. Blind Subagent)**
   The host coordinator starts your dev server or desktop app, keeps `README.md` and source files to itself, and passes **only a bare URL or window PID** to an isolated blind-tester subagent. The tester is strictly forbidden from reading repository files—it perceives your product solely through real rendered screenshots and mouse/keyboard actions.
2. **Stage 1: The 5-Second Blind Audit (No Deep Clicking Allowed)**
   Before touching deep CRUD features, Specs captures Desktop (`1440×900`) and Mobile (`390×844`) views (or the native desktop window) and answers four questions verbatim: *What is this? Who is it for? Where do I click first? What makes me want to bounce?* Then he audits **Visual Craft** (hierarchy, alignment, breathing room, half-baked native controls) and **Readability** (zero tolerance for raw enums, UUIDs, `undefined`, or developer jargon).
   - *Login wall?* He audits whether the gate explains product value first, attempts guest mode or self-signup like a real stranger, and halts cleanly (`AUTH_REQUIRED`) if blocked by CAPTCHAs, real OTPs, or OAuth—asking you for test credentials instead of hacking around auth.
3. **🔒 The Hard Gate (Fix + Fresh-Eyes Retest)**
   Stage 2 stays **locked**. The coordinator presents a prioritized Stage 1 issue table (`P0 Blocker` / `P1 Major` / `P2 Minor`) and waits for your call. Once patched, it spawns a **brand-new** blind subagent (never reusing the memory-tainted one!) to verify the first impression from scratch.
4. **Stage 2: Fluency & `F5`-Free Cross-View Linkage**
   Only after Stage 1 passes does Specs test interactive workflows: click feedback, layout shift (CLS), rapid double-click duplicate submission, form draft retention on error, dead-end screens, and **at least 5 cross-view state linkage chains with manual `F5` refresh strictly banned**:
   - **CRUD → Global Summary**: Add/edit/delete in View A → check Dashboard cards, charts, sidebar count badges, and global search in View B.
   - **Master-Detail & Selectors**: Rename/disable a tag or category in Settings → check dropdown selectors and list cards elsewhere.
   - **Navigation Context**: Search + filter + paginate to Page 2 → open Detail → click Back (and browser Back/Forward). Are filters and active nav highlights intact?
   - **Global Broadcast**: Toggle dark/light theme, language, or user profile → inspect modals, popovers, empty states, and charts for torn styling.
   - **Lifecycle Boundaries**: `0 items (Empty)` → `1st item` → `50-char title & special chars` → `Delete last item back to 0`.

---

## Intensity modes & signature footer

Switch strictness inline when invoking the skill:

| Mode | What Specs does |
| :--- | :--- |
| **`lite`** | **Quick Glance.** Runs the Phase 1 5-second intuition + visual/jargon check on the current screen only. Reports findings; touches zero code. |
| **`full`** | **Default.** Full blind subagent quarantine, user-approved Stage 1 fix & fresh-eyes retest gate, followed by Stage 2 fluency and 5+ `F5`-free linkage chains. |
| **`savage`** | **Zero-Mercy Churn Mode.** Flags `2px` misalignments, sluggish modals, and bloated toolbars; questions whether confusing UI elements should be **deleted outright** before fixing them. |

Every audit reply ends with **Specs' two-line verdict signature**, so you always see the gate status, blindness guarantee, and unchecked scope in one glance:

```markdown
---
👓 **UserSpec** (`full`) · Gate: `PHASE 1 LOCKED 🔒`
*“Didn't read your README. Gives you five seconds. Never hits F5 for you.”*
**Blindness & Scope**: Zero repo files read by tester · Verified: `/login`, `/dashboard` (`1440×900`, `390×844`) · Unchecked / Risks: Stage 2 linkage locked until P1-01 & P1-02 pass fresh retest.
```

---

## Install

### Antigravity

Clone UserSpec and point `.agents/skills.json` (project) or `~/.gemini/config/skills.json` (global) to `skills`:

```json
{
  "entries": [
    { "path": "/path/to/UserSpec/skills" }
  ]
}
```

### Claude Code

```text
/plugin marketplace add marksimZ/UserSpec
/plugin install userspec@userspec
```

### Codex CLI & IDE

```bash
mkdir -p ~/.agents/skills && git clone https://github.com/marksimZ/UserSpec.git /tmp/UserSpec && cp -R /tmp/UserSpec/skills/user-perspective-ux-audit ~/.agents/skills/user-perspective-ux-audit
```

### Cursor, Windsurf, Cline, Copilot & others

Load `skills/user-perspective-ux-audit/SKILL.md` as a skill, or copy the compact ruleset [`adapters/AGENTS.md`](adapters/AGENTS.md) into your target project. Step-by-step commands for Windows PowerShell, macOS, and Linux: **[INSTALL.md](INSTALL.md)**.

---

## Usage

```text
Run UserSpec on http://localhost:5173 — start with my first impression, then test cross-page linkage.
```

```text
$user-perspective-ux-audit savage
Audit our Electron desktop window ("QuantStudio") like a brand-new user. Don't read the repo first.
```

```text
用纯新用户视角（UserSpec）审查一下当前项目的界面和联动体验，先过第一印象门禁，不明确的地方先和我确认修改项。
```

---

## Repository layout

```text
UserSpec/
├── assets/                                           # Light/dark Specs mascot & workflow SVGs
├── skills/
│   └── user-perspective-ux-audit/
│       ├── SKILL.md                                  # Core persona, quarantine rules, modes & prompts
│       ├── agents/openai.yaml                        # Codex / OpenAI skill display metadata
│       ├── references/
│       │   ├── phase1-first-impression-checklist.md  # 5-second test, visual craft & anti-jargon rubric
│       │   ├── phase2-fluency-and-linkage-matrix.md  # Fluency checks & 6 F5-free cross-view chains
│       │   ├── platform-adapters.md                  # Web, Mobile H5 & Native/Electron execution guides
│       │   └── audit-report-template.md              # Stage 1 & Stage 2 report templates
│       └── scripts/
│           ├── capture_window.ps1                    # Zero-dependency DPI-aware Windows window capture
│           └── capture_window.sh                     # macOS & Linux window enumeration / capture helper
├── adapters/AGENTS.md                                # Compact drop-in ruleset for rules-only harnesses
├── .claude-plugin/                                   # Claude Code marketplace & plugin manifests
├── INSTALL.md                                        # Multi-agent setup guide
├── README.md                                         # English documentation (default)
├── README.zh-CN.md                                   # Simplified Chinese documentation
└── LICENSE                                           # MIT
```

---

## FAQ

**Why can't one agent just read the code to start the server and then "roleplay" a new user?**
Because you cannot un-read a spoiler. Once the context window contains your route table and component props, the model subconsciously knows what `"Workspace Quota Node"` means and where the create button hides. UserSpec keeps server startup in the coordinator and spawns a separate, unspoiled subagent for the eyes.

**Why lock Stage 2 behind Stage 1?**
Real users don't test your cross-page state synchronization if your landing screen confuses them into closing the tab at second four. Fix the front door first.

**What if my product is a developer tool—are raw enums fine then?**
Developers also drink coffee and hate reading `ERR_UPSTREAM_NULL_422` or misaligned buttons. Specs wears glasses, not a protocol analyzer.

**Why ban `F5` during Stage 2?**
Pressing `F5` because a mutation forgot to invalidate the dashboard cache is *developer* muscle memory. Real users just assume the save button silently failed—and click it three more times.

**Does it work on native desktop apps (WPF, Qt, Electron, Tauri)?**
Yes. On Windows, `capture_window.ps1` uses Win32 DWM extended frame bounds + `SetProcessDPIAware()` out of the box (zero Python/Node packages needed) so 125%–200% HiDPI windows render razor-sharp. macOS and Linux use `capture_window.sh`.

---

## License

[MIT](LICENSE). Short, readable, no legalese—Specs approved.
