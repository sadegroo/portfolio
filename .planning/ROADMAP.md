# Roadmap: Sadegroo Portfolio

**Created:** 2026-04-28
**Granularity:** coarse
**Core Value:** Pushing to `main` publishes the site at `sadegroo.github.io` — zero manual build steps, zero hosting cost.

## Phases

- [ ] **Phase 1: Foundation** — Hugo extended installed, site scaffolded in-place, PaperMod attached, hygiene rules locked in
- [ ] **Phase 2: Content Skeleton** — Posts/projects sections, about page, and BLDC pendulum draft seeded
- [ ] **Phase 3: Deploy Pipeline** — GitHub Actions workflow builds and deploys to `gh-pages` on push to `main`
- [ ] **Phase 4: Validate & Handoff** — Local smoke test passes; handoff report enumerates remaining manual steps

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
**Plans**: TBD

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
| 1. Foundation | 0/0 | Not started | - |
| 2. Content Skeleton | 0/0 | Not started | - |
| 3. Deploy Pipeline | 0/0 | Not started | - |
| 4. Validate & Handoff | 0/0 | Not started | - |

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
