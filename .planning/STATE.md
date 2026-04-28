# State: Sadegroo Portfolio

**Last updated:** 2026-04-28 (post-session refresh after BLDC post publish + patches)

## Project Reference

**Core Value:** Pushing to `main` publishes the site at `https://sadegroo.github.io/portfolio/` — zero manual build steps, zero hosting cost.

**Current Focus:** v1 milestone shipped and live. First real content (BLDC pendulum post) published. Site is operational and accepting new posts via the standard `hugo new posts/<slug>.md` → edit → `git push` workflow.

## Current Position

- **Milestone:** v1 (Initial scaffold) — **complete and live** ✅
- **Phase:** None active. Post-v1 work is happening ad-hoc outside the formal phase structure.
- **Status:** Site live at https://sadegroo.github.io/portfolio/. CI deploy pipeline working. First post published.
- **Progress:** [██████████] 100% (4 / 4 phases) + post-launch patches + first content shipped

## Performance Metrics

| Metric | Value |
|--------|-------|
| Phases planned | 4 |
| Phases complete | 4 |
| v1 requirements | 18 |
| Requirements satisfied | 18 |
| Coverage | 18/18 mapped, 18/18 verified |
| Posts published live | 1 (BLDC pendulum) |
| Posts in draft | 0 |
| Total commits on `main` | 14 |
| Latest commit pushed | `53c654a` (revert sync script) |

## Accumulated Context

### Decisions (from v1 milestone)
- Hugo + PaperMod stock + GitHub Pages via `peaceiris/actions-gh-pages` is prescriptive (no stack debate)
- Scaffold in-place at `C:/Users/u0130154/repos/portfolio` (do not re-clone)
- Install Hugo via `choco install hugo-extended` (Windows native, user preference); requires elevated shell
- Coarse granularity → 4 phases (Foundation, Content, Deploy, Validate & Handoff)
- Skipped pre-planning research (stack fully specified in PROJECT.md)

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

### Open TODOs (in the BLDC post, non-blocking)
4 placeholder visuals still commented out in `content/posts/bldc-pendulum/index.md`:
- 📷 Rig wide shot
- 🎥 Architecture animation (optional)
- 📷 Sim-vs-hardware overlay plot
- 📷 Competition leaderboard
- 🎥 Push-recovery clip

Each has a brief in the source explaining what to capture; uncomment the corresponding shortcode/HTML when each asset lands.

### Parked seeds
- `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` — custom subdomain switchover. Trigger: user mentions DNS setup for sadegroo.xyz, or is ready to publish under branded URL. Full step-by-step inside.

### Blockers
- None

### Risks
- Custom domain switchover (when triggered) involves a brief window where DNS may not yet have propagated; mitigation documented in the seed file.
- Hugo version drift between local install (currently v0.160.1) and CI workflow pin: if either is bumped, the other should be too. CIv2-01 in REQUIREMENTS.md tracks pinning via Renovate/Dependabot for later.

## Session Continuity

**Most recent session (2026-04-28):** Post-v1 patches and first content published. Full report: `.planning/reports/20260428-session-report.md`.

**Next natural actions:**
- Capture the remaining BLDC post visuals (rig shot, sim-vs-hardware plot, leaderboard, push-recovery clip) — uncomment shortcodes as each lands. No replan needed.
- Author the next post (3D printing or home automation, per POL-03). Use `hugo new posts/<slug>.md`; convert to a page bundle when assets accumulate.
- When DNS for `sadegroo.xyz` is configured, surface the custom-domain seed and walk through the switchover.

**Files of interest:**
- `.planning/PROJECT.md` — vision, validated requirements, decisions
- `.planning/REQUIREMENTS.md` — REQ-IDs and traceability
- `.planning/ROADMAP.md` — v1 phases (all complete)
- `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` — parked custom-domain plan
- `.planning/reports/20260428-session-report.md` — post-v1 session report
- `content/posts/bldc-pendulum/index.md` — first published post

**Working directory:** `C:/Users/u0130154/repos/portfolio` (Windows 11, bash shell)

---
*State initialized: 2026-04-28. Refreshed: 2026-04-28 after post-v1 session.*
