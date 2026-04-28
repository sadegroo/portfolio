# Roadmap: Sadegroo Portfolio

**Created:** 2026-04-28
**Granularity:** coarse
**Core Value:** Pushing to `main` publishes the site at `sadegroo.github.io` — zero manual build steps, zero hosting cost.

## Phases

- [x] **Phase 1: Foundation** — Hugo extended installed, site scaffolded in-place, PaperMod attached, hygiene rules locked in
- [x] **Phase 2: Content Skeleton** — Posts/projects sections, about page, and BLDC pendulum draft seeded
- [x] **Phase 3: Deploy Pipeline** — GitHub Actions workflow builds and deploys to `gh-pages` on push to `main`
- [x] **Phase 4: Validate & Handoff** — Local smoke test passes; handoff report enumerates remaining manual steps

## Phase Details

### Phase 1: Foundation
**Goal**: A clean, themed Hugo site exists in the working copy without disturbing the load-bearing README and LICENSE.
**Depends on**: Nothing (first phase)
**Requirements**: TOOL-01, TOOL-02, SCAF-01, SCAF-02, SCAF-03, SCAF-04, HYG-01, HYG-02, HYG-03
**Success Criteria** (what must be TRUE):
  1. `hugo version` reports an extended build at v0.120 or later on the Windows machine
  2. The working copy contains a Hugo site layout (`hugo.toml`, `archetypes/`, `content/`, etc.) and the original `README.md` + `LICENSE` are byte-identical to the pre-scaffold baseline
  3. PaperMod is present at `themes/PaperMod` as a registered git submodule with a captured commit SHA in `.gitmodules`
  4. `hugo.toml` declares title "Sadegroo", `languageCode = "en"`, theme `"PaperMod"`, search/tags/about-menu enabled, and a clearly-marked TODO for `baseURL`
  5. `.gitignore` excludes `public/`, `resources/`, and `.hugo_build.lock`
**Plans**: 1 plan
Plans:
- [x] 01-01-PLAN.md — Install Hugo extended, scaffold site in-place, attach PaperMod submodule, write documented hugo.toml + .gitignore, verify load-bearing files preserved

### Phase 2: Content Skeleton
**Goal**: The site has the two content sections and the seed pages a reader would expect to land on.
**Depends on**: Phase 1
**Requirements**: CONT-01, CONT-02, CONT-03, CONT-04
**Success Criteria** (what must be TRUE):
  1. `content/posts/` and `content/projects/` directories exist as recognized Hugo sections
  2. `content/about.md` exists as a placeholder About page
  3. `content/posts/bldc-pendulum.md` exists with the agreed front matter (title, tags `[embedded, control, STM32, BLDC]`, `draft = true`) and the five section headings (Overview, Hardware Setup, Control Architecture, Results, Source Code) each with placeholder text
  4. A reader running `hugo server` would see About in the menu and the BLDC draft listed on `/posts/` (when drafts are rendered)
**Plans**: TBD
**UI hint**: yes

### Phase 3: Deploy Pipeline
**Goal**: Pushing to `main` will trigger a CI build and deploy the rendered site to `gh-pages` without any manual steps or custom secrets.
**Depends on**: Phase 1 (needs the site to exist); independent of Phase 2 content but commits land after it
**Requirements**: CI-01, CI-02, CI-03
**Success Criteria** (what must be TRUE):
  1. `.github/workflows/deploy.yml` exists and is triggered on `push` to `main` and `workflow_dispatch`
  2. The workflow installs Hugo extended at a version matching the local install, checks out submodules recursively, and runs `hugo --minify` (or equivalent) producing `public/`
  3. The workflow deploys `public/` to the `gh-pages` branch via `peaceiris/actions-gh-pages@v3` (or current pinned major) using the default `GITHUB_TOKEN` — no PAT, no custom secret
  4. The YAML is well-formed and would be accepted by GitHub Actions on a `git push` (validated locally by static check or `actionlint`-style review)
**Plans**: TBD

### Phase 4: Validate & Handoff
**Goal**: The user has proof the site builds locally and a written list of the remaining manual steps to go live.
**Depends on**: Phases 1, 2, 3
**Requirements**: SMOKE-01, HAND-01
**Success Criteria** (what must be TRUE):
  1. `hugo server` starts cleanly with zero error-level log lines, serves the site, and is then stopped (no orphaned process)
  2. A handoff report shows the current `git status`, lists every file staged or committed during the milestone, and explicitly enumerates the remaining manual steps: (a) `git push origin main`, (b) enable GitHub Pages → source `gh-pages` branch in repo settings, (c) set the final `baseURL` in `hugo.toml`
  3. The user can act on the handoff list without re-reading the rest of `.planning/` — it stands alone
**Plans**: TBD

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 1/1 | ✅ Complete | 2026-04-28 |
| 2. Content Skeleton | 0/0 | ✅ Complete | 2026-04-28 |
| 3. Deploy Pipeline | 0/0 | ✅ Complete | 2026-04-28 |
| 4. Validate & Handoff | 0/0 | ✅ Complete | 2026-04-28 |

## Coverage

- v1 requirements: 18 total
- Mapped: 18 / 18
- Orphans: 0

| Phase | Requirements |
|-------|--------------|
| 1. Foundation | TOOL-01, TOOL-02, SCAF-01, SCAF-02, SCAF-03, SCAF-04, HYG-01, HYG-02, HYG-03 (9) |
| 2. Content Skeleton | CONT-01, CONT-02, CONT-03, CONT-04 (4) |
| 3. Deploy Pipeline | CI-01, CI-02, CI-03 (3) |
| 4. Validate & Handoff | SMOKE-01, HAND-01 (2) |

---
*Roadmap created: 2026-04-28*

---

## Milestone v2: Content & Custom Domain

**Started:** 2026-04-28
**Granularity:** coarse
**Goal:** Take the live scaffold from "shippable" to "a portfolio worth visiting": finish the BLDC post visuals, ship at least one more post, switch to the branded subdomain when DNS is ready, and harden CI for routine use.

**Note on patches between milestones:** Five PATCH-* items (PATCH-01..05) shipped post-v1 and are documented in `.planning/reports/20260428-session-report.md` and `REQUIREMENTS.md`. They are not retroactively wrapped as v2 phases — the v2 phases below are forward-looking work only.

## Phases (v2)

- [ ] **Phase 5: BLDC Visuals** — Fill the 4 placeholder visuals in the published BLDC pendulum post; closes POL-01
- [ ] **Phase 6: Second Post** — Author one additional post end-to-end as a page bundle (3D printing OR home automation)
- [ ] **Phase 7: Custom-Domain Switchover** — Move live URL from `sadegroo.github.io/portfolio/` to `pages.sadegroo.xyz` once user has configured DNS
- [ ] **Phase 8: CI Hardening** — Pin Hugo via Renovate/Dependabot; add a build-only PR check on non-main branches

## Phase Details (v2)

### Phase 5: BLDC Visuals
**Goal**: The published BLDC pendulum post is visually complete — every commented-out `{{< figure >}}` placeholder is replaced with a real asset that renders in production.
**Depends on**: v1 shipped (post is live as a page bundle with prose). Independent of Phase 6.
**Requirements**: VIS-01, VIS-02, VIS-03, VIS-04
**Success Criteria** (what must be TRUE):
  1. Files `rig-overview.jpg`, `sim-vs-hardware.png`, `competition-leaderboard.png`, and `push-recovery.mp4` exist inside the page bundle `content/posts/bldc-pendulum/`
  2. The corresponding `{{< figure >}}` shortcodes (and `<video>` tag for the clip) in `index.md` are uncommented and reference the new asset filenames bundle-relative
  3. After deploy, all four assets resolve with HTTP 200 at their published URLs (no 404s in DevTools network panel) and the `<video>` element plays in a current Chromium browser
  4. Competition leaderboard image has team-member names anonymised before commit
**Plans**: TBD

### Phase 6: Second Post
**Goal**: A second real post is published, end-to-end, as a page bundle — proving the BLDC post wasn't a one-off and the publish loop scales beyond one piece of content.
**Depends on**: v1 shipped. Independent of Phase 5 (different files).
**Requirements**: POST-01, POST-02, POST-03, POST-04, POST-05
**Success Criteria** (what must be TRUE):
  1. A new page bundle `content/posts/<slug>/index.md` exists with `draft = false`, a chosen topic (3D printing OR home automation), title, summary, tags, and 4–6 section headings filled with prose (~1,500–2,500 words)
  2. At least one image asset lives inside the same bundle directory and is referenced bundle-relative from the markdown
  3. The post is reachable at `https://<live-baseURL>/posts/<slug>/` and is listed on the `/posts/` index page
  4. Each tag declared on the post resolves to a tag page that lists the post (verifies tag taxonomy still works for new content)
**Plans**: TBD
**UI hint**: yes

### Phase 7: Custom-Domain Switchover
**Goal**: The site serves from `https://pages.sadegroo.xyz/` over HTTPS, with the old project URL redirecting cleanly. (See `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` for the full step-by-step.)
**Depends on**: v1 shipped. **Gated on external user action**: the phase plan must explicitly require the user to confirm DNS is configured at the registrar (CNAME `pages → sadegroo.github.io.`) and `dig +short pages.sadegroo.xyz` returns `sadegroo.github.io` before any repo or settings changes proceed. Independent of Phases 5 and 6 in terms of files touched.
**Requirements**: DOM-01, DOM-02, DOM-03, DOM-04, DOM-05, DOM-06
**Success Criteria** (what must be TRUE):
  1. `dig +short pages.sadegroo.xyz` returns `sadegroo.github.io` (DNS resolves correctly)
  2. `static/CNAME` exists in the repo with exactly one line `pages.sadegroo.xyz` (no protocol, no trailing slash) and `hugo.toml` has `baseURL = "https://pages.sadegroo.xyz/"`
  3. `https://pages.sadegroo.xyz/` returns HTTP 200 with a valid TLS certificate (no browser warnings); GitHub Pages settings show the green DNS-check tick and "Enforce HTTPS" is enabled
  4. `https://sadegroo.github.io/portfolio/` returns a 301 redirect to the new domain, and the seed file `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` has been archived (moved or marked `status: shipped`)
**Plans**: TBD

### Phase 8: CI Hardening
**Goal**: The deploy pipeline gets routine-maintenance ergonomics: Hugo version bumps arrive as PRs instead of silent drift, and broken branches fail loudly before merge instead of after.
**Depends on**: v1 shipped. Loosely depends on Phase 7 (so the Renovate config targets the final `deploy.yml`); most natural to run after Phase 7 but technically can run any time.
**Requirements**: CIH-01, CIH-02, CIH-03
**Success Criteria** (what must be TRUE):
  1. Either `renovate.json` or `.github/dependabot.yml` is committed to the repo and configured to track the Hugo version pin in `.github/workflows/deploy.yml`
  2. A second workflow (e.g. `.github/workflows/build-check.yml`) — or a branch-filtered job in `deploy.yml` — runs `hugo --minify` on PRs to `main` and on pushes to non-main branches, and explicitly does NOT deploy
  3. Renovate/Dependabot has opened at least one PR (even if no Hugo update is pending, the dry-run / first-scan PR counts) — proves the bot has repo access and the config parses
  4. A trivial PR cycle has been observed end-to-end: PR opened → build-check workflow runs and reports green → merge → deploy workflow runs and publishes
**Plans**: TBD

## Progress (v2)

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 5. BLDC Visuals | 0/0 | Not started | - |
| 6. Second Post | 0/0 | Not started | - |
| 7. Custom-Domain Switchover | 0/0 | Not started (gated on DNS) | - |
| 8. CI Hardening | 0/0 | Not started | - |

## Coverage (v2)

- v2 requirements: 18 total (VIS-01..04, POST-01..05, DOM-01..06, CIH-01..03)
- Mapped: 18 / 18
- Orphans: 0

| Phase | Requirements |
|-------|--------------|
| 5. BLDC Visuals | VIS-01, VIS-02, VIS-03, VIS-04 (4) |
| 6. Second Post | POST-01, POST-02, POST-03, POST-04, POST-05 (5) |
| 7. Custom-Domain Switchover | DOM-01, DOM-02, DOM-03, DOM-04, DOM-05, DOM-06 (6) |
| 8. CI Hardening | CIH-01, CIH-02, CIH-03 (3) |

---
*v2 milestone phases added: 2026-04-28*
