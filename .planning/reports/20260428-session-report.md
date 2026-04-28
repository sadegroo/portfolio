# GSD Session Report

**Generated:** 2026-04-28 16:15 +0200
**Project:** Sadegroo Portfolio
**Milestone:** v1 (Initial scaffold) — already closed before this session; all work below is post-milestone "first content + patches."

---

## Session Summary

**Duration:** ~3.5 hours (first commit 12:48, last 16:07 local)
**Phase Progress:** v1 100% complete; this session is post-milestone work outside the formal phase structure.
**Plans Executed:** 0 (no formal phase plans; ad-hoc inline work)
**Commits Made:** 7
**Lines changed:** +288 / −96 across 7 files (plus 4 MB binary assets)

## Work Performed

### Outside the formal phase structure

This session ran entirely after the v1 milestone closed. Two threads:

1. **Patches to the live site** that should arguably have been caught in v1's smoke test (search 404, subpath asset resolution, baseURL placeholder).
2. **The first real content** — the BLDC pendulum post, with hero image and swing-up clip — going from placeholder skeleton to published.

### Key Outcomes

| # | Commit | What | Why it mattered |
|---|--------|------|-----------------|
| 1 | `5e7d264` | Set `baseURL = "https://sadegroo.github.io/portfolio/"`; plant custom-domain seed | Live URL was decided; canonical / RSS / favicon URLs needed it. Custom-domain (`pages.sadegroo.xyz`) parked as a seed pending DNS setup. |
| 2 | `07412b2` | Add `content/search.md` (layout = "search") | PaperMod search needed both the JSON output AND a content page; we had only the first. /search/ was 404'ing on the live site. |
| 3 | `eb2a9f3` | Publish BLDC pendulum post draft + assets + Goldmark `unsafe = true` | First real content. Hugo strips raw HTML by default; needed `unsafe = true` for inline `<video>` tag to survive markdown rendering. |
| 4 | `9f8be47` | Flip `draft = false` on BLDC post | Post went live. |
| 5 | `015cfc0` | `canonifyURLs = true` in hugo.toml | Subpath gotcha: site lives at `/portfolio/` but `figure` shortcode and raw `<video>` emitted `/img/...` (root-relative). canonifyURLs rewrites root-relative URLs through baseURL during build. |
| 6 | `4e2bd97` | Convert BLDC post to page bundle; bundle scoping rewrite; title change; teaching-payoff rewrite; Greek-parens removal | Page bundle (`content/posts/bldc-pendulum/index.md` + co-located assets) replaces flat-file + `static/` layout. Title now leads with the digital-twin angle. Teaching framing reframed for the actual student level (empirical Simulink/Stateflow swing-up, not LQR/MPC). |
| 7 | `53c654a` | Revert: drop sync script; plain duplication for shared MATLAB images | Sync script was added prematurely. Personal-portfolio scale doesn't justify the infra. |

### Decisions Made (codified into the project)

- **canonifyURLs = true** in `hugo.toml`. Site is under `/portfolio/` subpath; without this, `figure` shortcodes and raw HTML asset paths break.
- **Goldmark unsafe = true**. Required for raw `<video>` and other inline HTML. Safe at this scale (no third-party markdown ingestion).
- **Page-bundle convention** for posts. Starting with `bldc-pendulum/`, posts that own assets get their own folder with `index.md` + co-located media. Asset paths in markdown become bundle-relative (`hero.png` not `/img/...`).
- **Plain duplication, not sync infra**, for assets shared across personal repos (e.g. MATLAB screenshots also used in `digtwin_labo` README). Captured as a feedback memory for future sessions.
- **Live URL strategy is staged.** Today: project-repo URL (`sadegroo.github.io/portfolio/`). Later: custom subdomain (`pages.sadegroo.xyz`) once DNS is configured. The latter is parked as a seed at `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` with full step-by-step.
- **Post title leads with the differentiator.** "One Simulink Model, Two Targets: A Digital Twin for an Inverted Pendulum" beats "Inverted Pendulum Stabilisation with BLDC Motor and STM32" because the twin/codegen angle is what makes the project distinctive.

### Gotchas Encountered (worth remembering)

These cost real time during the session and are likely to recur on the next post.

| Gotcha | Symptom | Fix |
|--------|---------|-----|
| **PaperMod search needs both JSON output AND a content page** | `/search/` 404 in browser, even with `outputs.home = ["HTML", "RSS", "JSON"]` set | Add `content/search.md` with `layout = "search"` |
| **Hugo strips raw HTML by default** | `<video>` tag silently disappears from rendered output (Goldmark omits it as unsafe; leaves `<!-- raw HTML omitted -->` comment) | Set `[markup.goldmark.renderer] unsafe = true` in hugo.toml |
| **Hugo dev server applies baseURL locally too** | Local `http://localhost:1313/` returns 404 for everything when baseURL is set to a subpath | Run dev server with `--baseURL "http://localhost:1313" --appendPort=false` |
| **Subpath baseURL breaks figure/video src** | Assets resolve to `sadegroo.github.io/img/...` instead of `sadegroo.github.io/portfolio/img/...` | Either `canonifyURLs = true` (catches all), or use page bundles with bundle-relative paths |
| **Choco install needs elevated shell** | `Access to the path 'lib-bad' is denied` even with `-y --no-progress` | Run install in elevated PowerShell; non-elevated cannot recover. (Resolved at Phase 1 already, recorded again here.) |

## Files Changed

```
.planning/seeds/custom-domain-pages-sadegroo-xyz.md   +66
content/posts/bldc-pendulum.md                        -91   (renamed)
content/posts/bldc-pendulum/index.md                 +194   (page bundle)
content/posts/bldc-pendulum/hero.png                 +1.1 MB (binary)
content/posts/bldc-pendulum/swingup.mp4              +3.0 MB (binary)
content/search.md                                     +12
hugo.toml                                             +21 / -5
```

Net: 7 files changed, 288 insertions, 96 deletions, ~4 MB binary assets added (well within GitHub's per-file and per-repo soft limits; no LFS needed).

## Blockers & Open Items

### Blockers
None. All commits pushed; site live.

### Open items / TODOs in the post

The published BLDC post still has 4 placeholder visuals waiting for capture:
- Rig wide shot (📷)
- Architecture animation (🎥, optional)
- Sim-vs-hardware overlay plot (📷)
- Competition leaderboard (📷)
- Push-recovery clip (🎥)

Each is a commented-out shortcode/HTML tag in `content/posts/bldc-pendulum/index.md`; uncomment when the asset lands. None of them block the post being live.

### Parked seeds

- `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` — switch to `https://pages.sadegroo.xyz/` once DNS for `sadegroo.xyz` is configured. Full step-by-step inside the seed file.

### v2 candidates (from REQUIREMENTS.md, still open)

- POL-01: replace BLDC pendulum draft placeholder text with real content (PARTIALLY DONE — full prose exists; only visuals remain)
- POL-02: set final `baseURL` in `hugo.toml` (DONE for current URL; pending again for custom domain)
- POL-03: more posts (3D printing, home automation, etc.)
- CIv2-01: pin Hugo via Renovate/Dependabot
- CIv2-02: build-only PR check on non-main branches

## Estimated Resource Usage

| Metric | Value |
|--------|-------|
| Commits | 7 |
| Files changed | 7 (+ 2 binary assets) |
| Plans executed | 0 (post-milestone work, no formal plans) |
| Subagents spawned | 2 (Explore agents to scout `invpend_BLDC` and `digtwin_labo` repos for the BLDC post draft) |
| Push operations | 4 (each batch of related commits pushed individually; standing rule of "review before push" was honored throughout) |

> Token and cost estimates not available without API-level instrumentation. The session was content-heavy (Explore agents read significant amounts of MATLAB / firmware source) but produced ~290 lines of markdown + 4 MB of media.

## Memory updates this session

- `~/.claude/projects/.../memory/feedback_no_premature_sync_infra.md` — default to plain duplication, not sync scripts, for personal-scale shared assets.

---

*Generated by `/gsd-session-report`*
