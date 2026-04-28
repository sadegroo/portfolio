# Sadegroo Portfolio

## What This Is

A personal portfolio and project blog for Sander ("sadegroo") covering embedded systems, control engineering, 3D printing, and home automation. Built as a static site with Hugo + the PaperMod theme, deployed to GitHub Pages from `github.com/sadegroo/portfolio` on push to `main`.

## Core Value

Pushing to `main` publishes the site at `sadegroo.github.io` — zero manual build steps, zero hosting cost. Everything else (themes, search, tags) is in service of that one loop working reliably.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Hugo extended toolchain installed and the existing `sadegroo/portfolio` repo scaffolded as a Hugo site (PaperMod added as submodule, `hugo.toml` configured, README + LICENSE preserved)
- [ ] Two content sections live: `posts/` (writeups) and `projects/` (per-project index pages), with search, tags, and an about page enabled
- [ ] GitHub Actions workflow at `.github/workflows/deploy.yml` builds with Hugo extended on push to `main` and deploys to the `gh-pages` branch via `peaceiris/actions-gh-pages`
- [ ] Initial content seeded: an `about.md` placeholder and one draft post `content/posts/bldc-pendulum.md` with the agreed section skeleton (Overview, Hardware Setup, Control Architecture, Results, Source Code)
- [ ] Repo hygiene in place: `.gitignore` excludes `public/`, `resources/`, `.hugo_build.lock`; existing README + LICENSE preserved untouched
- [ ] `hugo server` builds the site cleanly with no errors (smoke test before handoff)

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
| Use Hugo + PaperMod stock theme | Fastest path to a polished portfolio with search/tags built in; user prescribed it | — Pending |
| Deploy via `peaceiris/actions-gh-pages` to `gh-pages` branch | De-facto standard for Hugo on GitHub Pages; minimal config; aligns with README intent | — Pending |
| Scaffold in-place at `C:/Users/u0130154/repos/portfolio` rather than `~/portfolio` | Repo is already cloned here; avoids duplicate clone; user confirmed | — Pending |
| Install Hugo via `choco` (not winget/scoop) | User preference on Windows | — Pending |
| Skip pre-planning research | Stack is fully prescribed; PaperMod + Hugo + GH Pages is well-trodden ground; research would add tokens with no information gain | — Pending |
| Do NOT push or enable Pages remotely | User explicitly retains control of remote operations | — Pending |

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
*Last updated: 2026-04-28 after initialization*
