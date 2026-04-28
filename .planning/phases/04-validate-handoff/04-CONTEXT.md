# Phase 4: Validate & Handoff - Context

**Gathered:** 2026-04-28
**Status:** Ready for planning
**Mode:** Auto-generated (discuss skipped via workflow.skip_discuss)

<domain>
## Phase Boundary

Run `hugo server` once as a smoke test (no live serving left running), capture the result, then write a self-contained handoff report enumerating the manual steps the user needs to take post-milestone (push, enable Pages source, set baseURL).

</domain>

<decisions>
## Implementation Decisions

### Locked from REQUIREMENTS.md
- SMOKE-01: `hugo server` builds the site cleanly with no errors, then is stopped (no orphaned process)
- HAND-01: Final report includes git status, lists every committed file, and explicitly enumerates remaining manual steps

### Claude's Discretion
- Use `hugo server -D --port 1313 --bind 127.0.0.1` so the BLDC draft is exercised too (draft = true would otherwise be hidden). This validates more of the content scaffolding in one pass.
- Run a production `hugo --gc --minify` build first to confirm the published site doesn't include the draft (matches what CI will produce).
- Probe the home, About, Posts, Projects, search index, and BLDC draft routes via curl to prove templates actually render.
- Handoff lives in `04-HANDOFF.md` inside the phase directory so it's easy to find from `.planning/`.

</decisions>

<code_context>
## Existing Code Insights

- Phase 3's CI workflow runs `hugo --gc --minify` (no drafts). Production build must succeed without drafts.
- Phase 1 already verified Hugo extended v0.160.1 is on PATH.
- Phase 2's BLDC post is `draft = true`; it must NOT appear in production build but MUST appear with `-D`.

</code_context>

<specifics>
## Specific Ideas

The handoff report needs to stand alone — the user shouldn't have to re-read PROJECT.md or REQUIREMENTS.md to know what's left. Include all three remaining manual steps with the exact commands or click paths.

</specifics>

<deferred>
## Deferred Ideas

None — Phase 4 is the milestone tail.

</deferred>
