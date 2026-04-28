# Requirements: Sadegroo Portfolio

**Defined:** 2026-04-28
**Core Value:** Pushing to `main` publishes the site at `sadegroo.github.io` — zero manual build steps, zero hosting cost.

## v1 Requirements (all closed and live)

### Toolchain

- [x] **TOOL-01**: Hugo extended (≥ v0.120) is installed locally and `hugo version` reports an extended build
- [x] **TOOL-02**: If Hugo is missing, install it via `choco install hugo-extended` (Windows-native, per user preference)

### Scaffold

- [x] **SCAF-01**: Hugo site scaffolded into the existing `C:/Users/u0130154/repos/portfolio` working copy via `hugo new site . --force`, preserving the existing `README.md` and `LICENSE` byte-for-byte
- [x] **SCAF-02**: PaperMod theme added as a git submodule at `themes/PaperMod` from `https://github.com/adityatelange/hugo-PaperMod`
- [x] **SCAF-03**: `hugo.toml` is clean, documented (commented), and configured with `title = "Sadegroo"`, `languageCode = "en"`, theme `"PaperMod"`, and a clearly-marked TODO for `baseURL`
- [x] **SCAF-04**: PaperMod-specific config in `hugo.toml` enables search (output format `JSON` for the search index), tag taxonomy, and surfaces an About page in the main menu

### Content structure

- [x] **CONT-01**: `content/posts/` section exists for project writeups
- [x] **CONT-02**: `content/projects/` section exists for per-project index pages
- [x] **CONT-03**: `content/about.md` placeholder page exists
- [x] **CONT-04**: Draft post `content/posts/bldc-pendulum.md` exists with front matter `title = "Inverted Pendulum Stabilisation with BLDC Motor and STM32"`, `tags = [embedded, control, STM32, BLDC]`, `draft = true`, and body section headings: Overview, Hardware Setup, Control Architecture, Results, Source Code — each with placeholder text describing what the user should fill in. *(Superseded post-v1 — see PATCH-04 below; the placeholder draft was replaced with a published post and converted to a page bundle. Title changed to "One Simulink Model, Two Targets: A Digital Twin for an Inverted Pendulum".)*

### CI / Deploy

- [x] **CI-01**: `.github/workflows/deploy.yml` exists, triggers on `push` to `main` (and `workflow_dispatch`)
- [x] **CI-02**: The workflow installs Hugo extended (matching local version), checks out submodules recursively, builds the site, and deploys the `public/` directory to the `gh-pages` branch using `peaceiris/actions-gh-pages`
- [x] **CI-03**: The workflow uses the default `GITHUB_TOKEN` for `gh-pages` push — no custom secrets required

### Repo hygiene

- [x] **HYG-01**: `.gitignore` excludes `public/`, `resources/`, `.hugo_build.lock`
- [x] **HYG-02**: Existing `README.md` and `LICENSE` are unchanged after scaffolding (verify with `git diff` against `main` baseline)
- [x] **HYG-03**: PaperMod submodule registered in `.gitmodules` and the submodule SHA is captured (no detached/uninitialized state)

### Smoke test & handoff

- [x] **SMOKE-01**: `hugo server` builds the site cleanly with no errors, then is stopped (smoke test only — no live serving left running)
- [x] **HAND-01**: Final report shows `git status`, lists every change staged/committed, and explicitly enumerates remaining manual steps (push, enable GitHub Pages → `gh-pages` source, set `baseURL` in `hugo.toml`)

## Post-v1 patches and content shipped (2026-04-28 session)

These were not in the original v1 plan but landed in the same calendar day, post-launch. Closed and pushed.

- [x] **PATCH-01**: Set `baseURL = "https://sadegroo.github.io/portfolio/"` in `hugo.toml` (closes POL-02 for the project-repo URL; custom-domain switchover parked as a seed)
- [x] **PATCH-02**: Add `content/search.md` so the menu link `/search/` resolves (PaperMod recipe — JSON output alone wasn't enough)
- [x] **PATCH-03**: Enable `[markup.goldmark.renderer] unsafe = true` so inline HTML (`<video>`, etc.) survives the markdown renderer
- [x] **PATCH-04**: Set `canonifyURLs = true` so root-relative asset paths get rewritten through baseURL (subpath compatibility)
- [x] **PATCH-05**: Replace the BLDC pendulum placeholder draft with a published page-bundle post: full prose drafted from `invpend_BLDC` + `digtwin_labo` repos, hero image and swing-up clip wired in, `draft = false`. Substantial completion of POL-01 (visuals still pending — see open items below).

### Open items rolled forward

- **POL-01 (partial)**: BLDC post body is published with full prose; 4 placeholder visuals still commented out in `content/posts/bldc-pendulum/index.md` (rig wide shot, sim-vs-hardware overlay, leaderboard, push-recovery clip). Each is a brief in the source; uncomment as assets land.

## v2 Requirements (deferred)

### Polish

- **POL-01 (partial)**: BLDC pendulum post visuals — see "Open items rolled forward" above
- ~~**POL-02**~~: Set final `baseURL` once GitHub Pages domain is confirmed — *closed by PATCH-01 for project URL; custom subdomain (`pages.sadegroo.xyz`) parked as `.planning/seeds/custom-domain-pages-sadegroo-xyz.md`*
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

**Coverage:**
- v1 requirements: 18 total, 18 verified ✅
- Post-v1 patches: 5 (PATCH-01..05), all live
- Open: POL-01 partial (visuals), POL-03 (more posts), CIv2-01, CIv2-02

| Requirement | Phase | Status |
|-------------|-------|--------|
| TOOL-01 | Phase 1 | ✅ Verified |
| TOOL-02 | Phase 1 | ✅ Verified |
| SCAF-01 | Phase 1 | ✅ Verified |
| SCAF-02 | Phase 1 | ✅ Verified |
| SCAF-03 | Phase 1 | ✅ Verified |
| SCAF-04 | Phase 1 | ✅ Verified |
| HYG-01 | Phase 1 | ✅ Verified |
| HYG-02 | Phase 1 | ✅ Verified |
| HYG-03 | Phase 1 | ✅ Verified |
| CONT-01 | Phase 2 | ✅ Verified |
| CONT-02 | Phase 2 | ✅ Verified |
| CONT-03 | Phase 2 | ✅ Verified |
| CONT-04 | Phase 2 | ✅ Verified (superseded by PATCH-05) |
| CI-01 | Phase 3 | ✅ Verified |
| CI-02 | Phase 3 | ✅ Verified |
| CI-03 | Phase 3 | ✅ Verified |
| SMOKE-01 | Phase 4 | ✅ Verified |
| HAND-01 | Phase 4 | ✅ Verified |
| PATCH-01 | post-v1 | ✅ Live |
| PATCH-02 | post-v1 | ✅ Live |
| PATCH-03 | post-v1 | ✅ Live |
| PATCH-04 | post-v1 | ✅ Live |
| PATCH-05 | post-v1 | ✅ Live (visuals partial) |

---
*Requirements defined: 2026-04-28*
*Last updated: 2026-04-28 after post-v1 session (PATCH-01..05 added; v1 reqs marked verified)*
