---
phase: 04-validate-handoff
plan: 04
type: execute
wave: 1
depends_on: ["01-foundation/01", "02-content-skeleton/02", "03-deploy-pipeline/03"]
files_modified:
  - .planning/phases/04-validate-handoff/04-HANDOFF.md
autonomous: true
requirements:
  - SMOKE-01
  - HAND-01
must_haves:
  truths:
    - "hugo server starts cleanly, serves the site, and is then stopped (no orphan process)"
    - "Production hugo build succeeds and excludes the draft"
    - "Handoff report enumerates the 3 manual steps remaining (push, Pages source, baseURL)"
---

<objective>
Prove the site builds locally and produce a self-contained handoff report.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Production build sanity (matches CI behavior)</name>
  <action>
    Run `hugo --gc --minify` and confirm exit 0, page count > 0, and that `public/posts/bldc-pendulum/` does NOT exist (draft excluded). Then `rm -rf public/`.
  </action>
</task>

<task type="auto">
  <name>Task 2: Smoke test hugo server -D (SMOKE-01)</name>
  <action>
    Start `hugo server -D --port 1313 --bind 127.0.0.1` in the background. Poll `http://127.0.0.1:1313/` until 200 OK (max 15s). Probe /, /about/, /posts/, /projects/, /index.json, /posts/bldc-pendulum/. Stop the server. Verify no `hugo` process remains.
  </action>
  <done>
    All probes return 200; server log has no `error|warn|fatal` lines; no orphan process.
  </done>
</task>

<task type="auto">
  <name>Task 3: Write handoff report (HAND-01)</name>
  <files>.planning/phases/04-validate-handoff/04-HANDOFF.md</files>
  <action>
    Write a self-contained markdown report covering: project state, what was committed (git log + git status), smoke test results, and the 3 remaining manual steps with exact commands / click paths.
  </action>
</task>

</tasks>

<verification>

| REQ-ID | Check |
|--------|-------|
| SMOKE-01 | hugo server smoke test green, no orphan process |
| HAND-01 | 04-HANDOFF.md exists; lists git state + 3 manual steps |

</verification>
