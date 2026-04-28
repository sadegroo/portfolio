# Sadegroo Portfolio — Milestone Handoff

**Date:** 2026-04-28
**Working copy:** `C:/Users/u0130154/repos/portfolio` (Windows 11, Git Bash)
**Branch:** `main`, working tree clean
**Status:** ✅ All 18 v1 requirements closed locally. Nothing pushed. Pages not yet enabled.

---

## What was built

A complete, deployable Hugo + PaperMod portfolio scaffold with CI in place. The site builds clean locally; pushing to `main` will trigger an automatic deploy to `gh-pages` once you enable Pages.

### Tech stack pins

| Item | Value |
|------|-------|
| Hugo | `v0.160.1` extended |
| PaperMod (submodule) | SHA `e457685` (tag `v8.0-122-ge457685`) |
| CI | `.github/workflows/deploy.yml` — `peaceiris/actions-hugo@v3` + `peaceiris/actions-gh-pages@v4` |
| Auth | default `GITHUB_TOKEN` (no PAT, no custom secret) |

### Smoke test (just ran)

`hugo server -D --port 1313` started in <1s, served the site, stopped cleanly. All routes 200 OK:

| Route | Status |
|-------|--------|
| `/` | 200 |
| `/about/` | 200 |
| `/posts/` | 200 |
| `/projects/` | 200 |
| `/index.json` (search) | 200 |
| `/posts/bldc-pendulum/` (draft, only with `-D`) | 200 |

Production build (`hugo --gc --minify`, what CI runs) emitted 12 pages and correctly excluded the draft. No errors or warnings.

---

## Commits made on `main` (local only — not pushed)

```
f89ca10 feat(03): add GitHub Actions deploy workflow
5a3bd44 feat(02): seed content skeleton (posts, projects, about, BLDC draft)
486a097 docs(02): auto-generated context (discuss skipped)
ef2b2d7 feat(01): scaffold Hugo + PaperMod foundation
055604a docs(01): plan Phase 1 (Foundation)
5056302 docs(01): auto-generated context (discuss skipped)
c149fbc chore: skip discuss (prescriptive milestone)
67dad54 docs: create roadmap (4 phases)
9188611 docs: define v1 requirements
4c6adf7 chore: add project config
38ff882 docs: initialize project
```

`git status --short` — clean (Phase 4 commit will be the only thing left to make).

### Files added by the milestone

```
.github/workflows/deploy.yml      ← CI (Phase 3)
.gitignore                         ← Hugo build artifacts (Phase 1)
.gitmodules                        ← PaperMod submodule (Phase 1)
.planning/                         ← GSD planning artifacts
CLAUDE.md                          ← Project instruction file (gen)
archetypes/default.md              ← Hugo scaffold (Phase 1)
content/about.md                   ← About placeholder (Phase 2)
content/posts/_index.md            ← Posts section (Phase 2)
content/posts/bldc-pendulum.md     ← BLDC draft, draft=true (Phase 2)
content/projects/_index.md         ← Projects section (Phase 2)
hugo.toml                          ← Site config (Phase 1)
themes/PaperMod/                   ← Submodule pointer (Phase 1)
```

`README.md` and `LICENSE` were preserved byte-identical to the pre-scaffold baseline (verified after every phase via `git diff HEAD -- README.md LICENSE` returning empty).

---

## ▶ Remaining manual steps (3)

These were intentionally NOT done — you retain control of all remote operations.

### 1. Review and push to `origin`

```bash
cd C:/Users/u0130154/repos/portfolio
git log --oneline origin/main..main          # review the 11 commits about to land
git push origin main
```

Pushing kicks off `.github/workflows/deploy.yml`, which builds the site and creates the `gh-pages` branch (first run only).

### 2. Enable GitHub Pages in repo settings

After the first successful workflow run (creates `gh-pages`):

```
GitHub → repo settings → Pages
  Source:        Deploy from a branch
  Branch:        gh-pages
  Folder:        / (root)
  → Save
```

Pages will start serving at `https://sadegroo.github.io/` within a minute or two.

### 3. Set the final `baseURL` in `hugo.toml`

Currently a TODO comment (left blank so local dev defaults to `/`). Once you know the live URL:

```toml
# Edit hugo.toml — uncomment and set the right value:
baseURL = "https://sadegroo.github.io/"      # or your custom domain
```

Commit, push — the next CI run picks it up.

---

## Optional follow-ups (parked, not blocking)

- Replace BLDC pendulum draft placeholder text with real content; flip `draft = false`.
- Author the next post (3D printing, home automation, etc.).
- Pin the Hugo version to a Renovate/Dependabot-managed range so CI bumps are tracked.
- Add a PR build check on non-main branches (build only, no deploy).

These are all in `REQUIREMENTS.md` under v2 (POL-* and CIv2-*) and can be picked up in a later milestone.

---

## How to resume work

```bash
cd C:/Users/u0130154/repos/portfolio
hugo server -D                    # local preview (drafts visible)
hugo --gc --minify                # production build into public/
git status                        # see what you've changed
```

`/gsd-progress` from inside this directory will show full project state at any point.
