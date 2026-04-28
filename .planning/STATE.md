---
gsd_state_version: 1.0
milestone: v2
milestone_name: Content & Custom Domain
status: planning
last_updated: "2026-04-28T15:54:05.782Z"
last_activity: 2026-04-28
progress:
  total_phases: 0
  completed_phases: 0
  total_plans: 0
  completed_plans: 0
  percent: 0
---

# State: Sadegroo Portfolio

**Last updated:** 2026-04-28 (post-session refresh after BLDC post publish + patches)

## Project Reference

**Core Value:** Pushing to `main` publishes the site at `https://sadegroo.github.io/portfolio/` — zero manual build steps, zero hosting cost.

**Current Focus:** Milestone v2 (Content & Custom Domain) just started. Phases 5–8 mapped: BLDC visuals, second post, custom-domain switchover (gated on DNS), CI hardening. All 18 v2 requirements pending.

## Current Position

Phase: Not started (defining requirements)
Plan: —
Status: Defining requirements
Last activity: 2026-04-28 — Quick task 260428-q02: dual-rig rewrite of BLDC post (now covers both stepper and BLDC variants)

## Performance Metrics

| Metric | v1 (shipped) | v2 (active) |
|--------|--------------|-------------|
| Milestone status | ✅ Complete | 🟡 Planning |
| Phases planned | 4 | 4 (#5–8) |
| Phases complete | 4 | 0 |
| Requirements | 18 | 18 |
| Requirements satisfied | 18 | 0 |
| Coverage | 18/18 verified | 18/18 mapped, 0 verified |

**Cumulative across all milestones:**
- Posts published live: 1 (BLDC pendulum)
- Posts in draft: 0
- Total commits on `main`: 16+ (latest pushed: see `git log -1`)
- Post-v1 patches landed: 5 (PATCH-01..05; see `.planning/reports/20260428-session-report.md`)

## Accumulated Context

### Decisions (from v1 milestone)

- Hugo + PaperMod stock + GitHub Pages via `peaceiris/actions-gh-pages` is prescriptive (no stack debate)
- Scaffold in-place at `C:/Users/u0130154/repos/portfolio` (do not re-clone)
- Install Hugo via `choco install hugo-extended` (Windows native, user preference); requires elevated shell
- Coarse granularity → 4 phases (Foundation, Content, Deploy, Validate & Handoff)
- Skipped pre-planning research (stack fully specified in PROJECT.md)

### Decisions (added 2026-04-28, dual-rig rewrite)

- **The BLDC pendulum post covers both rigs (stepper + BLDC), not just BLDC.** The framework supports two hardware variants of the STEVAL-EDUKIT01: the stock stepper rig (L6474, 1 kHz acceleration cmd) and the BLDC rig (FOC on IHM08M1, 16 kHz torque cmd). Both share the kit frame, NUCLEO-F401RE, pendulum encoder, Pi/Simulink/grading layer. Future content edits should preserve this framing — don't accidentally re-flatten to "BLDC-only."
- **Title kept as "One Simulink Model, Two Targets."** "Two Targets" = simulation + hardware (the variant-subsystem deployment trick). The stepper-vs-BLDC choice is a *second* variant switch, layered underneath. Clarifying parenthetical lives in the digital-twin section.
- **Stepper firmware repo (`sadegroo/invpend_stepper`) listed alongside `invpend_BLDC` and `digtwin_labo`** in the post's "Try it / source" section. URL/visibility still has a TODO marker — confirm before any push to publish.

### Decisions (added post-v1, this session)

- **`canonifyURLs = true`** in `hugo.toml` — required because the site lives at `/portfolio/` subpath; without it, `figure` shortcodes and raw HTML asset paths emit root-relative URLs that 404
- **`[markup.goldmark.renderer] unsafe = true`** — needed for inline `<video>` and other raw HTML in markdown to survive Goldmark's renderer; safe at this scale (no third-party markdown ingestion)
- **Page-bundle convention for posts.** Posts that own assets get a folder (e.g. `content/posts/bldc-pendulum/index.md` + co-located media). Asset paths in markdown are bundle-relative.
- **Plain duplication, not sync infra,** for assets shared with companion repos (e.g. MATLAB screenshots also in `digtwin_labo` README). Captured as feedback memory.
- **Live URL is staged.** Today: `sadegroo.github.io/portfolio/`. Later: custom subdomain `pages.sadegroo.xyz` once DNS configured. See `.planning/seeds/custom-domain-pages-sadegroo-xyz.md`.

### Gotchas codified (so they don't re-cost time on the next post)

- PaperMod search needs BOTH `outputs.home = JSON` AND a `content/search.md` with `layout = "search"`. JSON alone gives the data; without the content page, the menu link 404s.
- Hugo dev server applies baseURL locally too. When baseURL is a subpath, run dev server with `--baseURL "http://localhost:1313" --appendPort=false` to get clean local URLs.
- `choco install` requires elevated shell. Always.
- **Menu items in `[[menu.main]]` must use `url = "about/"` (no leading slash)** when baseURL is a subpath. PaperMod renders nav as `{{ .URL | absLangURL }}`, and `absLangURL` on a path starting with `/` treats it as site-absolute and drops baseURL's path component — links 404. `pageRef` has the same problem. (Root cause logged in commit `4614140`; details in `hugo.toml` comment block.)

### Open TODOs (in the BLDC post, non-blocking)

4 placeholder visuals still commented out in `content/posts/bldc-pendulum/index.md`:

- 📷 Rig wide shot
- 🎥 Architecture animation (optional)
- 📷 Sim-vs-hardware overlay plot
- 🎥 Push-recovery clip

(📷 Competition leaderboard landed 2026-04-28 via quick task 260428-q01 — replaced with `scoring_theta.png` + `scoring_pi.png` from the grading script.)

Each remaining item has a brief in the source explaining what to capture; uncomment the corresponding shortcode/HTML when each asset lands.

### Parked seeds

- `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` — custom subdomain switchover. Trigger: user mentions DNS setup for sadegroo.xyz, or is ready to publish under branded URL. Full step-by-step inside.

### Blockers

- None

### Quick Tasks Completed

| # | Description | Date | Commit | Directory |
|---|-------------|------|--------|-----------|
| 260428-q01 | Add scoring figures (Theta + Pi) to BLDC post competition section | 2026-04-28 | fd5ff30 | [260428-q01-bldc-leaderboard-figures](./quick/260428-q01-bldc-leaderboard-figures/) |
| 260428-q02 | BLDC post: dual-rig rewrite (one kit, two motor variants — stepper + BLDC) | 2026-04-28 | _pending_ | [260428-q02-dual-rig-rewrite](./quick/260428-q02-dual-rig-rewrite/) |

### Risks

- Custom domain switchover (when triggered) involves a brief window where DNS may not yet have propagated; mitigation documented in the seed file.
- Hugo version drift between local install (currently v0.160.1) and CI workflow pin: if either is bumped, the other should be too. CIv2-01 in REQUIREMENTS.md tracks pinning via Renovate/Dependabot for later.

## Session Continuity

**Most recent activity:** v2 milestone (Content & Custom Domain) started. ROADMAP.md extended with phases 5–8. REQUIREMENTS.md adds 18 new REQ-IDs (VIS-*, POST-*, DOM-*, CIH-*). PROJECT.md updated with the new milestone section.

**Next natural actions** (Phases 5 and 6 are parallel-safe; pick either):

- `/gsd-plan-phase 5` — BLDC post visuals (4 commented-out shortcodes need their assets). Quickest win.
- `/gsd-plan-phase 6` — Second post (3D printing or home automation, your topic choice).
- `/gsd-plan-phase 7` — Custom-domain switchover. **Do not plan this yet** unless DNS for `sadegroo.xyz` is configured. Otherwise the phase will block waiting for `dig` to resolve.
- `/gsd-plan-phase 8` — CI hardening (Renovate + PR build check). Self-contained, can run any time.

**Files of interest:**

- `.planning/PROJECT.md` — vision, current milestone v2, validated requirements, decisions
- `.planning/REQUIREMENTS.md` — REQ-IDs and traceability (v1 verified, v2 pending)
- `.planning/ROADMAP.md` — v1 phases (1–4, complete) + v2 phases (5–8, pending)
- `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` — full custom-domain step-by-step (now activated as Phase 7)
- `.planning/reports/20260428-session-report.md` — post-v1 session report
- `content/posts/bldc-pendulum/index.md` — first published post

**Working directory:** `C:/Users/u0130154/repos/portfolio` (Windows 11, bash shell)

---
*State initialized: 2026-04-28. Refreshed for v2 milestone start: 2026-04-28.*
