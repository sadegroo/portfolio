# Requirements: Sadegroo Portfolio

**Defined:** 2026-04-28
**Core Value:** Pushing to `main` publishes the site at `sadegroo.github.io` — zero manual build steps, zero hosting cost.

## v1 Requirements

### Toolchain

- [ ] **TOOL-01**: Hugo extended (≥ v0.120) is installed locally and `hugo version` reports an extended build
- [ ] **TOOL-02**: If Hugo is missing, install it via `choco install hugo-extended` (Windows-native, per user preference)

### Scaffold

- [ ] **SCAF-01**: Hugo site scaffolded into the existing `C:/Users/u0130154/repos/portfolio` working copy via `hugo new site . --force`, preserving the existing `README.md` and `LICENSE` byte-for-byte
- [ ] **SCAF-02**: PaperMod theme added as a git submodule at `themes/PaperMod` from `https://github.com/adityatelange/hugo-PaperMod`
- [ ] **SCAF-03**: `hugo.toml` is clean, documented (commented), and configured with `title = "Sadegroo"`, `languageCode = "en"`, theme `"PaperMod"`, and a clearly-marked TODO for `baseURL`
- [ ] **SCAF-04**: PaperMod-specific config in `hugo.toml` enables search (output format `JSON` for the search index), tag taxonomy, and surfaces an About page in the main menu

### Content structure

- [ ] **CONT-01**: `content/posts/` section exists for project writeups
- [ ] **CONT-02**: `content/projects/` section exists for per-project index pages
- [ ] **CONT-03**: `content/about.md` placeholder page exists
- [ ] **CONT-04**: Draft post `content/posts/bldc-pendulum.md` exists with front matter `title = "Inverted Pendulum Stabilisation with BLDC Motor and STM32"`, `tags = [embedded, control, STM32, BLDC]`, `draft = true`, and body section headings: Overview, Hardware Setup, Control Architecture, Results, Source Code — each with placeholder text describing what the user should fill in

### CI / Deploy

- [ ] **CI-01**: `.github/workflows/deploy.yml` exists, triggers on `push` to `main` (and `workflow_dispatch`)
- [ ] **CI-02**: The workflow installs Hugo extended (matching local version), checks out submodules recursively, builds the site, and deploys the `public/` directory to the `gh-pages` branch using `peaceiris/actions-gh-pages`
- [ ] **CI-03**: The workflow uses the default `GITHUB_TOKEN` for `gh-pages` push — no custom secrets required

### Repo hygiene

- [ ] **HYG-01**: `.gitignore` excludes `public/`, `resources/`, `.hugo_build.lock`
- [ ] **HYG-02**: Existing `README.md` and `LICENSE` are unchanged after scaffolding (verify with `git diff` against `main` baseline)
- [ ] **HYG-03**: PaperMod submodule registered in `.gitmodules` and the submodule SHA is captured (no detached/uninitialized state)

### Smoke test & handoff

- [ ] **SMOKE-01**: `hugo server` builds the site cleanly with no errors, then is stopped (smoke test only — no live serving left running)
- [ ] **HAND-01**: Final report shows `git status`, lists every change staged/committed, and explicitly enumerates remaining manual steps (push, enable GitHub Pages → `gh-pages` source, set `baseURL` in `hugo.toml`)

## v2 Requirements

Deferred — not in this milestone.

### Polish

- **POL-01**: Replace BLDC pendulum draft placeholder text with real content
- **POL-02**: Set final `baseURL` in `hugo.toml` once GitHub Pages domain is confirmed
- **POL-03**: Author additional posts covering 3D printing and home automation topics

### CI hardening

- **CIv2-01**: Pin Hugo version in workflow to a specific patch release and bump it via Renovate/Dependabot
- **CIv2-02**: Add a build-only PR check on non-main branches (no deploy)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Custom theme / theme fork | PaperMod stock is the brief; no design work this milestone |
| Pushing to `origin` or enabling Pages in GitHub UI | User explicitly retains control of remote operations |
| Real post body content (BLDC or otherwise) | Out of scope; the BLDC post ships as a structured placeholder for the user to fill |
| Custom domain / DNS configuration | `baseURL` left as TODO; domain decision is user's, post-deploy |
| Comments, analytics, RSS customization, multilingual content | Not v1 — not part of the core publish loop |
| Server-side search, dynamic backend, forms | Would break the static GitHub Pages model |
| Re-cloning into `~/portfolio` | Working copy already exists at `C:/Users/u0130154/repos/portfolio`; user confirmed in-place |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| TOOL-01 | TBD | Pending |
| TOOL-02 | TBD | Pending |
| SCAF-01 | TBD | Pending |
| SCAF-02 | TBD | Pending |
| SCAF-03 | TBD | Pending |
| SCAF-04 | TBD | Pending |
| CONT-01 | TBD | Pending |
| CONT-02 | TBD | Pending |
| CONT-03 | TBD | Pending |
| CONT-04 | TBD | Pending |
| CI-01 | TBD | Pending |
| CI-02 | TBD | Pending |
| CI-03 | TBD | Pending |
| HYG-01 | TBD | Pending |
| HYG-02 | TBD | Pending |
| HYG-03 | TBD | Pending |
| SMOKE-01 | TBD | Pending |
| HAND-01 | TBD | Pending |

**Coverage:**
- v1 requirements: 18 total
- Mapped to phases: 0 (filled by roadmapper)
- Unmapped: 18 — to be resolved during roadmap creation

---
*Requirements defined: 2026-04-28*
*Last updated: 2026-04-28 after initialization*
