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

## v2 Requirements — Content & Custom Domain (active)

### Phase 5 — BLDC post visuals (closes POL-01)

- [ ] **VIS-01**: Capture rig wide shot (📷). Bench setup with NUCLEO + IHM08M1 + motor + pendulum + Pi visible. Add as `content/posts/bldc-pendulum/rig-overview.jpg` and uncomment the matching `{{< figure >}}` shortcode in `index.md`.
- [ ] **VIS-02**: Generate sim-vs-hardware overlay plot (📷). Single plot, two traces (Simulink sim + real hardware capture from Simulink Data Inspector) for a swing-up trajectory. Add as `content/posts/bldc-pendulum/sim-vs-hardware.png`.
- [ ] **VIS-03**: Capture / render competition leaderboard (📷). Screenshot of `competition_results_*.xlsx` or a MATLAB bar chart. Anonymise team-member names. Add as `content/posts/bldc-pendulum/competition-leaderboard.png`.
- [ ] **VIS-04**: Capture push-recovery clip (🎥). ~5 sec slo-mo of pendulum recovering from a tap. Compress to MP4 (≤ 5 MB). Add as `content/posts/bldc-pendulum/push-recovery.mp4`.

### Phase 6 — Second post (partial POL-03)

- [ ] **POST-01**: Choose topic for second post (3D printing OR home automation). Decision logged in PROJECT.md Key Decisions.
- [ ] **POST-02**: Create page bundle `content/posts/<slug>/index.md` with title, summary, tags, draft = true, and 4–6 section headings appropriate to the topic.
- [ ] **POST-03**: Draft full prose (target ~1,500–2,500 words). At least one image (hero or inline). Page-bundle layout from the start.
- [ ] **POST-04**: Local smoke test (`hugo server -D`); verify post renders cleanly with assets. Flip `draft = false`. Push.
- [ ] **POST-05**: Verify post is live and discoverable from `/posts/`, and that tag pages list it under the right tag(s).

### Phase 7 — Custom-domain switchover (closes the parked seed)

- [ ] **DOM-01**: Add DNS CNAME record at registrar: `pages → sadegroo.github.io.` (TTL 1h). Verify with `dig +short pages.sadegroo.xyz`.
- [ ] **DOM-02**: Add `static/CNAME` file containing `pages.sadegroo.xyz` (single line, no protocol).
- [ ] **DOM-03**: Update `hugo.toml` baseURL: `https://sadegroo.github.io/portfolio/` → `https://pages.sadegroo.xyz/`. Commit + push.
- [ ] **DOM-04**: GitHub repo settings → Pages → Custom domain → `pages.sadegroo.xyz` → Save. Wait for green DNS-check tick.
- [ ] **DOM-05**: Tick "Enforce HTTPS" once cert provisions (~5 min after DNS check passes). Verify `https://pages.sadegroo.xyz/` loads with no cert warning and assets resolve. Old project URL should 301-redirect.
- [ ] **DOM-06**: Archive the seed file `.planning/seeds/custom-domain-pages-sadegroo-xyz.md` once switchover verified live.

### Phase 8 — CI hardening (closes CIv2-01, CIv2-02)

- [ ] **CIH-01**: Add `renovate.json` (or `.github/dependabot.yml`) configured to bump the Hugo version pin in `.github/workflows/deploy.yml` automatically and open PRs for review.
- [ ] **CIH-02**: Add `.github/workflows/build-check.yml` (or extend `deploy.yml` with branch filter) that builds the site on push to non-main branches and on PRs to `main`, but does NOT deploy. Catches "this branch breaks the build" before merging.
- [ ] **CIH-03**: Verify both new workflows run cleanly on at least one PR cycle (open a trivial PR, observe build, merge, observe deploy).

### Out of scope for v2 (parked for v3 or beyond)

- **POL-03 (full)**: Multiple additional posts across all topic areas — POST-* covers exactly one in v2; further posts will accumulate naturally without needing milestone wrapping each time.
- Comments / analytics / RSS customization / multilingual content (still excluded per Core Value).
- Image processing pipeline (auto-resize, WebP conversion, srcset) — premature optimization for current scale.

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
- v2 requirements: 18 total (VIS-01..04, POST-01..05, DOM-01..06, CIH-01..03), all pending — mapped to phases 5–8

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
| VIS-01 | Phase 5 | Pending |
| VIS-02 | Phase 5 | Pending |
| VIS-03 | Phase 5 | Pending |
| VIS-04 | Phase 5 | Pending |
| POST-01 | Phase 6 | Pending |
| POST-02 | Phase 6 | Pending |
| POST-03 | Phase 6 | Pending |
| POST-04 | Phase 6 | Pending |
| POST-05 | Phase 6 | Pending |
| DOM-01 | Phase 7 | Pending |
| DOM-02 | Phase 7 | Pending |
| DOM-03 | Phase 7 | Pending |
| DOM-04 | Phase 7 | Pending |
| DOM-05 | Phase 7 | Pending |
| DOM-06 | Phase 7 | Pending |
| CIH-01 | Phase 8 | Pending |
| CIH-02 | Phase 8 | Pending |
| CIH-03 | Phase 8 | Pending |

---
*Requirements defined: 2026-04-28*
*Last updated: 2026-04-28 after v2 milestone start (VIS-*, POST-*, DOM-*, CIH-* mapped to phases 5–8)*
