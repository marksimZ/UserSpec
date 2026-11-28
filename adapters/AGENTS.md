# UserSpec — Compact Rules Adapter (`AGENTS.md` / `.cursorrules`)

> Copy this file into a target project's `AGENTS.md`, `CLAUDE.md`, or `.cursor/rules/userspec.mdc` when using a rules-only coding agent that does not load `skills/user-perspective-ux-audit/SKILL.md` natively.

## Usability Lab Protocol (Three-Stage Zero-Context End-User Audit)

When asked to review, test, or polish UI/UX, run a structured three-stage zero-context usability audit using depth modes `glance` (Stage 1 report only), `gate` (default three-stage gatekept loop), or `stress` (exhaustive boundary & linkage stress test).

### Non-Negotiable Rules

1. **Zero-Spoiler Quarantine**: Whenever subagents are available, the coordinator starts the server/window and passes **only** the bare URL or window handle to a separate blind-tester subagent. Never leak `README.md`, route names, or feature lists to the tester. Never read source code before forming the first impression.
2. **Auth & Onboarding Gate**: If greeted by a login wall, audit whether product value is explained before demanding credentials. Try guest mode or self-signup first; stop immediately (`AUTH_REQUIRED`) on CAPTCHAs, real SMS/email OTPs, OAuth-only gates, or paywalls and ask the user for a test account. Re-run the 5-second test upon reaching the main workspace.
3. **Stage 1 Gate (First Impression · Visual Craft · Readability)**:
   - Before clicking deep features, capture desktop (`1440×900`) and mobile (`390×844`) views.
   - Answer verbatim: *What does this appear to do? Who is it for? What is the primary CTA? What creates immediate friction?*
   - Flag hierarchy noise, misalignment, poor contrast, empty states without guidance, and **developer leaks** (`STATUS_PENDING`, `undefined`, raw ISO timestamps, UUIDs, internal jargon).
   - **STOP** and ask the user which Stage 1 issues to fix. Patch approved items and re-verify with a **brand-new** blind subagent before unlocking Stage 2.
4. **Stage 2 Gate (Unguided Full-Feature Discovery & End-to-End Workflow Completion)**:
   - Coordinator silently builds a secret Ground-Truth Ledger of all features (`F-01..F-N`, including context menus, text selections, drag-drop, shortcuts) and end-to-end workflows (`W-01..W-M` with final DoD).
   - **Pass 1 (Zero-Hint)**: Blind subagent exhausts visible affordances and completes workflows end-to-end with realistic data, returning a Blind Mental Map.
   - **Pass 2 (Goal-Only Nudge)**: For missed Ghost Features, give ONLY the plain-language user goal (no UI/button hints) to distinguish `P1 Discoverability` from `P0 Workflow Blocker`.
   - **STOP** for user-approved fixes and re-verify with a **brand-new** blind subagent before unlocking Stage 3.
5. **Stage 3 (Fluency & F5-Free Cross-View Linkage)**:
   - Test click feedback, loading skeletons vs. layout shift, rapid double-click duplicate submission, form input retention on error, and dead-end screens.
   - Run **at least 5 cross-view linkage chains without pressing `F5`**: CRUD in View A → verify Dashboard/Badges/Search in View B; detail/settings rename → verify list/dropdown sync; filter/page persistence across Back/Forward; theme/locale/profile propagation across modals and charts; `0 → 1 → N → 0` item lifecycle.
6. **Lab Receipt Footer**: End every UX audit reply with:
   - `**UserSpec Lab Receipt** | Mode: <glance|gate|stress> | Gate: <STAGE 1 LOCKED | STAGE 1 PASSED | STAGE 2 LOCKED | STAGE 2 PASSED | STAGE 3 VERIFIED>`
   - `**Isolation**: Blind subagent (0 repo files read) · **Inspected**: <routes/viewports> · **Coverage**: Discovery X/N · Workflows Y/M · **Pending / Risks**: <items>`
