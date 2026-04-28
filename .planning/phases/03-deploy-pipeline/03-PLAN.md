---
phase: 03-deploy-pipeline
plan: 03
type: execute
wave: 1
depends_on: ["01-foundation/01"]
files_modified:
  - .github/workflows/deploy.yml
autonomous: true
requirements:
  - CI-01
  - CI-02
  - CI-03
must_haves:
  truths:
    - ".github/workflows/deploy.yml exists and is valid YAML"
    - "Triggers on push to main and on workflow_dispatch"
    - "Checkout uses submodules: recursive (themes/PaperMod must come down in CI)"
    - "Hugo install pins extended build matching local Phase 1 install (v0.160.1)"
    - "Build runs hugo --minify (no --buildDrafts; BLDC post stays unpublished)"
    - "Deploy uses peaceiris/actions-gh-pages@v4 to gh-pages branch"
    - "Auth uses default GITHUB_TOKEN — no PAT, no custom secret"
---

<objective>
Author the GitHub Actions workflow that will publish the site once the user pushes to `main`. The user explicitly retains control of remote ops — this phase only writes the YAML.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Write .github/workflows/deploy.yml (CI-01, CI-02, CI-03)</name>
  <files>.github/workflows/deploy.yml</files>
  <action>
    Create `.github/workflows/deploy.yml` with:
    - `on: { push: { branches: [main] }, workflow_dispatch: }`
    - `concurrency: { group: pages-deploy, cancel-in-progress: true }`
    - `permissions: { contents: write }`
    - `env: { HUGO_VERSION: "0.160.1", HUGO_ENV: production }`
    - One `build-and-deploy` job on `ubuntu-latest`:
      1. `actions/checkout@v4` with `submodules: recursive` and `fetch-depth: 0`
      2. `peaceiris/actions-hugo@v3` with `hugo-version: ${{ env.HUGO_VERSION }}`, `extended: true`
      3. `hugo --gc --minify` (no `--buildDrafts`)
      4. `peaceiris/actions-gh-pages@v4` with `github_token: ${{ secrets.GITHUB_TOKEN }}`, `publish_dir: ./public`, `publish_branch: gh-pages`
  </action>
  <done>
    All `must_haves.truths` from frontmatter hold; `python -c "import yaml; yaml.safe_load(open('.github/workflows/deploy.yml'))"` parses cleanly.
  </done>
</task>

</tasks>

<verification>

| REQ-ID | Check |
|--------|-------|
| CI-01 | File exists, push-on-main + workflow_dispatch triggers present |
| CI-02 | submodules:recursive + setup-hugo extended + Hugo version + peaceiris/actions-gh-pages@v4 + publish_branch gh-pages |
| CI-03 | github_token uses `${{ secrets.GITHUB_TOKEN }}` only; no `secrets.PAT_*` or `secrets.DEPLOY_*` references |

Cross-phase invariant: `git diff HEAD -- README.md LICENSE` empty.

</verification>
