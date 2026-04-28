# Phase 2: Content Skeleton - Context

**Gathered:** 2026-04-28
**Status:** Ready for planning
**Mode:** Auto-generated (discuss skipped via workflow.skip_discuss)

<domain>
## Phase Boundary

Seed the two content sections (`posts/` and `projects/`), an `about.md` placeholder, and the BLDC pendulum draft post. PaperMod's stock theme is the renderer — no template/layout work; no design decisions. ROADMAP carries a UI hint, but PROJECT.md "Out of Scope" explicitly excludes any theme/UI customization, so no UI-SPEC is needed.

Out of bounds: CI workflow (Phase 3), smoke testing (Phase 4), real post body content (deferred to v2 — POL-01).

</domain>

<decisions>
## Implementation Decisions

### Locked from REQUIREMENTS.md
- `content/posts/` exists (CONT-01) — section for project writeups
- `content/projects/` exists (CONT-02) — section for per-project index pages
- `content/about.md` placeholder exists (CONT-03) — surfaced via `[[menu.main]] About` already wired in Phase 1
- `content/posts/bldc-pendulum.md` exists (CONT-04) with EXACTLY this front matter:
  - `title = "Inverted Pendulum Stabilisation with BLDC Motor and STM32"`
  - `tags = ["embedded", "control", "STM32", "BLDC"]`
  - `draft = true`
  - body: section headings `Overview`, `Hardware Setup`, `Control Architecture`, `Results`, `Source Code` — each with placeholder text instructing the user what to fill in

### Claude's Discretion
- Use `_index.md` files for the `posts/` and `projects/` sections so PaperMod treats them as branch bundles with a list page (this is the idiomatic Hugo way to mark a section as "exists" — empty `posts/` would not be visible).
- Front matter format: TOML (`+++` delimiters) to match the project-wide `hugo.toml` convention. Hugo accepts YAML/TOML/JSON in any combination, but staying consistent with the site config keeps grep/diff predictable for the user.
- Date stamps: use 2026-04-28 (today) for the BLDC draft; user can change later. About/section indexes don't need dates.

</decisions>

<code_context>
## Existing Code Insights

- Phase 1 added `themes/PaperMod` submodule and wired `outputs.home = ["HTML", "RSS", "JSON"]`, `[taxonomies] tag = "tags"`, and a 3-entry main menu (About, Posts, Search).
- PaperMod's default templates render `content/posts/` as a list page automatically when the section has at least one `_index.md` or any leaf bundle.
- No custom layouts in `layouts/` — phase will not add any.

</code_context>

<specifics>
## Specific Ideas

The BLDC post body should explicitly tell the user what to put under each heading (e.g., "Overview: 1-2 paragraphs on what the project achieves, link to the GitHub repo"). Placeholder text needs to be useful for a future writing session, not lorem ipsum.

</specifics>

<deferred>
## Deferred Ideas

- Real BLDC content (deferred — POL-01)
- Posts on 3D printing / home automation (deferred — POL-03)
- Projects index entries beyond directory existence (deferred — needs real project pages)

</deferred>
