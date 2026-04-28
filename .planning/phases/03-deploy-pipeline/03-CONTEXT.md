# Phase 3: Deploy Pipeline - Context

**Gathered:** 2026-04-28
**Status:** Ready for planning
**Mode:** Auto-generated (discuss skipped via workflow.skip_discuss)

<domain>
## Phase Boundary

Add `.github/workflows/deploy.yml` so pushing to `main` builds the site with Hugo extended (matching the locally pinned version) and publishes the rendered `public/` to the `gh-pages` branch. Uses the default `GITHUB_TOKEN` — no PAT, no custom secrets.

Out of bounds: actually pushing the workflow to GitHub, enabling Pages in repo settings, configuring custom domains. Phase 4 enumerates these as manual handoff steps.

</domain>

<decisions>
## Implementation Decisions

### Locked from REQUIREMENTS.md
- Workflow file path: `.github/workflows/deploy.yml` (CI-01)
- Triggers: `push` on `main` AND `workflow_dispatch` (CI-01, manual re-run is useful)
- Build: Hugo extended, version matching the locally pinned `v0.160.1` (per Phase 1 SUMMARY tech-stack pins)
- Submodule checkout: `actions/checkout@v4` with `submodules: recursive` so `themes/PaperMod` lands in CI (CI-02)
- Deploy: `peaceiris/actions-gh-pages@v4` to `gh-pages` (CI-02)
- Auth: default `GITHUB_TOKEN` only (CI-03) — `peaceiris/actions-gh-pages@v4` accepts `github_token: ${{ secrets.GITHUB_TOKEN }}` for same-repo `gh-pages` publishing

### Claude's Discretion
- Pin `peaceiris/setup-hugo` action to `@v3` (current stable) and pass `hugo-version: '0.160.1'` and `extended: true`. Setup-hugo's `0.160.1` will resolve to the same Hugo extended build the user has locally; the action handles the platform binary download.
- Use `hugo --gc --minify` in CI (no `--buildDrafts` — drafts must NOT publish; CONT-04's BLDC post is `draft = true`).
- Concurrency group `pages-deploy` with `cancel-in-progress: true` to avoid overlapping deploys when commits land fast.
- Permissions block: `contents: write` (peaceiris pushes to `gh-pages`). Default `pages: read` not needed since we don't use the official `actions/deploy-pages`.
- Environment variables: `HUGO_VERSION: '0.160.1'` and `HUGO_ENV: production` set at the job level so they're easy for the user to bump from one place.

</decisions>

<code_context>
## Existing Code Insights

- Phase 1 pinned Hugo to `v0.160.1+extended` (per `01-01-SUMMARY.md`).
- `themes/PaperMod` is a git submodule at SHA `e457685` (per `01-01-SUMMARY.md`). CI must check out submodules or builds will fail with "no such theme: PaperMod".
- `hugo.toml` does not set `baseURL`; Hugo will fall back to `/` for builds. That's fine for an initial deploy — Phase 4 handoff explicitly tells the user to set `baseURL` before going live.

</code_context>

<specifics>
## Specific Ideas

The user explicitly stated: do NOT push or enable Pages in GitHub UI during this milestone. The workflow file is created locally and committed; the user reviews and pushes manually. This phase produces the YAML, nothing more.

</specifics>

<deferred>
## Deferred Ideas

- Renovate/Dependabot pinning (CIv2-01)
- Build-only PR check on non-main branches (CIv2-02)

</deferred>
