# Sadegroo Portfolio

## What This Is

A personal portfolio and project blog for Sander ("sadegroo") covering embedded systems, control engineering, 3D printing, and home automation. Built as a static site with Hugo + the PaperMod theme, deployed to GitHub Pages from `github.com/sadegroo/portfolio` on push to `main`.

## Core Value

Pushing to `main` publishes the site at `https://sadegroo.github.io/portfolio/` — zero manual build steps, zero hosting cost. Everything else (themes, search, tags) is in service of that one loop working reliably.

## Requirements

### Validated

- ✓ Hugo extended toolchain installed; `sadegroo/portfolio` scaffolded as a Hugo site, PaperMod added as submodule, `hugo.toml` configured, README + LICENSE preserved — *v1 Phase 1*
- ✓ Two content sections live: `posts/` and `projects/`, with search, tags, and an About page in the main menu — *v1 Phase 2 + post-v1 PATCH-02*
- ✓ GitHub Actions workflow builds on push to `main` and deploys to the `gh-pages` branch via `peaceiris/actions-gh-pages` — *v1 Phase 3*
- ✓ `.gitignore` excludes `public/`, `resources/`, `.hugo_build.lock`; README + LICENSE preserved verbatim through scaffolding — *v1 Phase 1*
- ✓ `hugo server` builds cleanly; site live at https://sadegroo.github.io/portfolio/ — *v1 Phase 4*
- ✓ `baseURL` set to project-repo URL; site renders with correct canonical / RSS / asset paths — *post-v1 PATCH-01 + PATCH-04*
- ✓ `/search/` route resolves with live search index (PaperMod recipe: JSON output + `content/search.md`) — *post-v1 PATCH-02*
- ✓ Inline HTML allowed in markdown (Goldmark `unsafe = true`) so `<video>` and similar tags survive the renderer — *post-v1 PATCH-03*
- ✓ First real post published: "One Simulink Model, Two Targets: A Digital Twin for an Inverted Pendulum" with hero image and swing-up clip; converted to a page bundle — *post-v1 PATCH-05*

### Active

- [ ] Fill the 4 remaining placeholder visuals in the BLDC post (rig wide shot, sim-vs-hardware overlay, leaderboard, push-recovery clip) — POL-01 partial
- [ ] Author additional posts (3D printing, home automation, etc.) — POL-03
- [ ] When DNS for `sadegroo.xyz` is configured, switch to custom subdomain `pages.sadegroo.xyz` — see `.planning/seeds/custom-domain-pages-sadegroo-xyz.md`

### Out of Scope

- Custom theme / theme fork — PaperMod stock is the brief; no design work this milestone
- Pushing to `origin` or enabling GitHub Pages in repo settings — user reviews and pushes manually
- Real post content (the BLDC post is a structured placeholder; user fills text later)
- Custom domain / DNS / `baseURL` finalization — left as a `# TODO` in `hugo.toml`
- Comments, analytics, RSS customization, multilingual content — not in v1
- Any non-static backend (forms, search index server-side, etc.) — would break the GitHub Pages model

## Context

- Repo `sadegroo/portfolio` already exists on GitHub with just `README.md` and `LICENSE`. The README sketches the intended stack (Hugo + PaperMod + GitHub Actions to `gh-pages`) — this project scaffolds toward that vision.
- Local working copy is already cloned at `C:/Users/u0130154/repos/portfolio` on Windows 11. We work in-place rather than re-cloning to `~/portfolio`.
- User is sole maintainer; no team review process to design around. CI is purely build-and-deploy.
- Topic seed posts will cover BLDC motor control / pendulum stabilization (STM32, FOC), 3D printing, home automation — the BLDC pendulum post is the first scaffolded draft.

## Constraints

- **Tech stack**: Hugo extended (≥ v0.120), PaperMod theme (git submodule), GitHub Actions, GitHub Pages → `gh-pages` branch via `peaceiris/actions-gh-pages`. Brief is prescriptive; no stack debate.
- **Platform**: Windows 11 dev environment. Package install via Chocolatey (`choco install hugo-extended`). No WSL/Linux assumptions.
- **Repo state**: README.md and LICENSE on the remote are load-bearing — must be preserved verbatim through scaffolding (`hugo new site . --force` must not clobber them).
- **No remote git ops**: Do not push, do not enable Pages in GitHub settings, do not create branches on remote. User reviews locally and pushes manually.
- **Cost**: Free tier only — GitHub Pages + Actions on a public repo. No paid hosting, no paid CI minutes.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use Hugo + PaperMod stock theme | Fastest path to a polished portfolio with search/tags built in; user prescribed it | ✓ Good |
| Deploy via `peaceiris/actions-gh-pages` to `gh-pages` branch | De-facto standard for Hugo on GitHub Pages; minimal config; aligns with README intent | ✓ Good |
| Scaffold in-place at `C:/Users/u0130154/repos/portfolio` rather than `~/portfolio` | Repo is already cloned here; avoids duplicate clone; user confirmed | ✓ Good |
| Install Hugo via `choco` (not winget/scoop) | User preference on Windows | ✓ Good |
| Skip pre-planning research | Stack is fully prescribed; PaperMod + Hugo + GH Pages is well-trodden ground; research would add tokens with no information gain | ✓ Good |
| Do NOT push or enable Pages remotely (during v1) | User explicitly retains control of remote operations | ✓ Good (relaxed post-v1: user authorized push for content patches and explicit ones) |
| `canonifyURLs = true` in hugo.toml | Site lives at `/portfolio/` subpath. Without it, `figure` shortcodes and raw HTML asset paths emit root-relative URLs and 404 in production. Auto-adapts when baseURL changes (e.g. to custom domain). | ✓ Good (post-v1) |
| Goldmark `unsafe = true` | Required for inline `<video>` and other raw HTML in markdown to survive the renderer. Safe at this scale (no third-party markdown ingestion). | ✓ Good (post-v1) |
| Page-bundle layout for posts that own assets | Co-locates post + media in one directory. URL stays the same; asset paths in markdown become bundle-relative; `git rm -r` cleans up everything when retiring a post. | ✓ Good (post-v1, applied to BLDC post) |
| Plain duplication for assets shared with companion repos | Personal-portfolio scale doesn't justify sync infra. Sync script was prototyped and reverted. | ✓ Good (post-v1) |
| Stage live URL: project-repo first, custom subdomain later | Validate the deploy pipeline at the project URL before adding the DNS variable. Custom subdomain (`pages.sadegroo.xyz`) parked as a seed. | ✓ Good (post-v1) |
| Lead post titles with the differentiator, not the hardware | "One Simulink Model, Two Targets: A Digital Twin for an Inverted Pendulum" beats "Inverted Pendulum Stabilisation with BLDC Motor and STM32" because the codegen / digital-twin angle is what's distinctive. | ✓ Good (post-v1, applied to BLDC post) |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-28 after post-v1 session (BLDC publish + patches; see `.planning/reports/20260428-session-report.md`)*
