# oh-my-codex v0.8.2

Released: **2026-03-06**

This is a **targeted patch release** focused on team-provider expansion, safer defaults, setup hygiene, and a couple of correctness fixes in keyword handling and OpenClaw hook templating.

---

## TL;DR

- `$team` / team runtime can now launch **Gemini CLI workers** alongside Codex and Claude (`#576`, `#579`, related issue `#573`).
- Default frontier-model fallback is now routed through **`DEFAULT_FRONTIER_MODEL`** instead of hardcoded model strings (`#583`).
- Setup is stricter about installing only **catalog-active/internal skills** and cleans stale shipped dirs on `--force` (`#575`, `#580`, closes `#574`).
- Fixed two patch-level bugs: unresolved OpenClaw placeholders (`#581`, closes `#578`) and keyword detection ordering/`/prompts` guarding (`#582`).

---

## What changed

### 1) Team mode: Gemini CLI worker support

OMX team mode now supports **Gemini** as a worker CLI provider in addition to Codex and Claude.

Included in this update:
- Gemini worker launch support in runtime/session resolution
- mixed CLI maps with Codex / Claude / Gemini workers
- `--model` passthrough support for Gemini workers
- expanded runtime and tmux-session coverage for Gemini worker behavior

**Why this matters:**
- more flexibility for mixed-provider teams
- easier experimentation with provider-specific worker roles
- better parity across the team orchestration surface

### 2) Model fallback defaults are now centralized

Hardcoded default frontier-model fallback references were replaced with `DEFAULT_FRONTIER_MODEL`.

Current behavior from this release:
- default frontier fallback now resolves through a single constant
- that constant is currently set to **`gpt-5.4`**
- low-complexity spark default remains **`gpt-5.3-codex-spark`**

**Why this matters:**
- fewer hidden fallback mismatches
- easier future model updates
- cleaner test and config semantics

### 3) Setup/install behavior is cleaner and safer

Setup now respects the catalog manifest more strictly:
- installs only `active` / `internal` skills
- skips deprecated / merged / alias entries
- removes stale shipped skill directories during `--force` cleanup

**Why this matters:**
- cleaner installs
- fewer stale shipped assets after upgrades
- lower chance of confusing doctor/setup results

### 4) Patch fixes

Two correctness fixes landed in this release:

- **OpenClaw template safety:** unresolved placeholders in hook instruction templates now fall back safely instead of leaking literal placeholders into instructions (`#581`, closes `#578`).
- **Keyword detection hardening:** explicit multi-skill order is preserved left-to-right, missing keyword aliases were restored, and direct `/prompts:<name>` invocations are protected from unintended implicit keyword activation (`#582`).

---

## Related PRs and issues

### Merged PRs in this release
- #583 — feat: use `DEFAULT_FRONTIER_MODEL` for default model fallback
- #582 — fix(keyword): explicit multi-skill order + `/prompts` guard hardening
- #581 — fix(openclaw): prevent unresolved placeholder leakage in hook instruction templates
- #580 — fix(setup): skip non-installable skills and cleanup stale shipped dirs
- #579 — feat(team): add Gemini CLI worker support
- #576 — feat(team): add Gemini CLI worker support (`#573`)
- #575 — fix: setup skips deprecated/merged/alias catalog skills
- #571 — docs: improve OpenClaw gateway configuration examples

### Related issues tagged in this release
- #573 — feat(team): add Gemini CLI worker support to OMX team mode
- #574 — setup should skip non-installable catalog skills and clean stale shipped dirs
- #578 — unresolved placeholder leakage in OpenClaw hook instruction templates

---

## Scope and commit window

Release scope was prepared from non-merge commits in:
- `v0.8.1..dev`

Snapshot at preparation time:
- **10 non-merge commits** (`2026-03-05` to `2026-03-06`)
- **57 files changed** (`+1,408 / -154`)

---

## Verification summary

Release verification evidence is recorded in `docs/qa/release-readiness-0.8.2.md`.

Planned release gates:
- `npm run build`
- `npm test`
- `npm run check:no-unused`
- CLI smoke checks (`--help`, `version`, `status`, `doctor`, `setup --dry-run`, `cancel`)

---

Thanks for using **oh-my-codex**. If anything regresses, please open an issue with reproduction steps, logs, and your CLI/runtime details.
