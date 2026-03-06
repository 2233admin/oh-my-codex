# Release Readiness Verdict - 0.8.2

Date: **2026-03-06**
Target version: **0.8.2**
Verdict: **GO** ✅

## Scope reviewed

- Version bump to `0.8.2` (`package.json`, `package-lock.json`)
- Changelog update (`CHANGELOG.md`)
- Release note draft (`docs/release-notes-0.8.2.md`)

## Validation evidence

| Check | Command | Result |
|---|---|---|
| Build | `npm run build` | PASS (`0:07.67`) |
| Full test suite | `npm test` | PASS (`1928` pass / `0` fail, `4:45.64`) |
| No-unused type gate | `npm run check:no-unused` | PASS (`0:04.00`) |
| CLI help smoke | `node bin/omx.js --help` | PASS |
| Version smoke | `node bin/omx.js version` | PASS (`oh-my-codex v0.8.2`) |
| Status smoke | `node bin/omx.js status` | PASS |
| Doctor smoke | `node bin/omx.js doctor` | PASS (`9 passed, 0 warnings, 0 failed`) |
| Setup dry-run smoke | `node bin/omx.js setup --dry-run` | PASS |
| Cancel smoke | `node bin/omx.js cancel` | PASS |

## Risk notes

- No failing checks were observed in release validation.
- `npm test` runtime remains several minutes because of the expected long-running integration coverage in notification/tmux/team paths.
- Release notes explicitly tag merged PRs `#571`, `#575`, `#576`, `#579`, `#580`, `#581`, `#582`, `#583` and related issues `#573`, `#574`, `#578`.

## Final verdict

Release **0.8.2** is **ready to publish** based on current local verification evidence.
