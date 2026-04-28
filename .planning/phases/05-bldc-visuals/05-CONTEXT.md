# Phase 5: BLDC Visuals - Context

**Gathered:** 2026-04-28
**Status:** Ready for planning
**Mode:** Auto-generated (discuss skipped via workflow.skip_discuss)

<domain>
## Phase Boundary

Fill the 4 placeholder visual shortcodes already commented out in `content/posts/bldc-pendulum/index.md`. Each placeholder has a `📷` or `🎥` brief in the source describing what to capture and a pre-typed `{{< figure >}}` or `<video>` tag to uncomment.

**Visuals to land:**
- VIS-01: rig wide shot (📷)
- VIS-02: sim-vs-hardware overlay plot (📷)
- VIS-03: competition leaderboard (📷)
- VIS-04: push-recovery clip (🎥)

Out of bounds: rewriting the post prose, changing the page-bundle structure, capturing the optional architecture animation (the placeholder is marked optional).

</domain>

<decisions>
## Implementation Decisions

### Locked from PROJECT.md / REQUIREMENTS.md / hugo.toml
- All assets land in the page bundle: `content/posts/bldc-pendulum/<filename>` (next to `index.md`). Asset paths in markdown stay bundle-relative (just the filename, no `/img/...` prefix).
- File-format rules from earlier in the project: JPEG (q85, ~1400 px wide) for photos, PNG for screenshots/plots/text-heavy diagrams, MP4 (H.264, `--gc --minify`-friendly) for video. No GIF for video.
- Page bundle stays committed in-repo; no Git LFS at this scale (4 MB current bundle + maybe 5–10 MB additional is well under thresholds).
- Each new asset uncomments the corresponding shortcode/HTML in `index.md` in the same commit. Don't ship orphan assets the post doesn't reference, and don't uncomment shortcodes that point at missing files (Hugo build will hard-fail with `unsafe = true` enabled).

### Claude's Discretion
- Whether to combine `scoring_pi.png` + `scoring_theta.png` into a single VIS-03 figure or include them as two figures with separate captions — see "Open question for plan-phase" below. This is a content-shape decision the planner can resolve when laying out tasks.
- Caption text for each figure (default: keep short, factual, link to repo source where relevant).
- Whether VIS-04 (push-recovery clip) should also have a poster frame attribute (`<video poster="...">`) — nice-to-have, not required.

</decisions>

<code_context>
## Existing Code Insights

- Page-bundle layout already in place: `content/posts/bldc-pendulum/{index.md, hero.png, swingup.mp4}`.
- 4 commented-out placeholder shortcodes already exist in `index.md` with full briefs in adjacent HTML comments. Search for `📷` and `🎥` markers in the file.
- Goldmark `unsafe = true` is enabled site-wide, so raw `<video>` tags survive the markdown renderer.
- `canonifyURLs = true` is enabled, so any root-relative path (`/foo`) gets prepended with baseURL — but bundle-relative paths (just `filename.ext`) are left alone and resolve correctly against the page URL.

### User-supplied raw material (added during this milestone, currently untracked)

The user has dropped 3 files into the BLDC bundle that look like raw material for VIS-03:

| File | Size | Format | What it is |
|------|------|--------|------------|
| `scoring.txt` | 556 B | plain text | Stepper-track leaderboard table: Team Theta + Team Pi, columns BestSwingupTime, BestSMAPE, TimePoints, SMAPEPoints, ParticipationPoint, TotalPoints, Rank. Both teams currently tied at rank 1. |
| `scoring_pi.png` | 80 KB | PNG | Likely a per-team breakdown / scoring detail view for Team Pi (not yet inspected visually) |
| `scoring_theta.png` | 80 KB | PNG | Likely the same for Team Theta |

These are all leaderboard / scoring artifacts. They do NOT match VIS-03's spec'd filename `competition-leaderboard.png` (one combined image), but they're clearly the right *kind* of material.

</code_context>

<specifics>
## Specific Ideas

The post's "teaching lab" section already describes the dual-axis scoring (speed + SMAPE) in prose. VIS-03's job is to make that concrete with one clean figure. Given the user-supplied material is two per-team PNGs plus a tabular text dump, the planner has options.

</specifics>

<deferred>
## Deferred Ideas

- The optional 🎥 architecture animation (signal-flow loop). Marked optional in the post; not in scope for VIS-* but could be added in a future polish pass.

</deferred>

<open_questions_for_plan_phase>
## Open question the planner should resolve

**VIS-03 visual shape:** how to use the user's raw material?

Three plausible approaches:
1. **Single combined figure (matches current spec):** Compose one PNG that includes both teams' scores in a single readable visual. Easiest to embed; cleanest in the post flow. Could be a screenshot of the `scoring.txt` rendered nicely, or a 2-pane composition of the two existing PNGs.
2. **Two figures, side by side or stacked:** Embed `scoring_pi.png` and `scoring_theta.png` as two separate `{{< figure >}}` blocks with linked captions. Preserves what the user already produced; minimal extra work. Renames the files to `competition-pi.png` / `competition-theta.png` for clarity.
3. **Tabular embed + one supporting figure:** Render `scoring.txt` directly as a markdown table inline in the post (it's already formatted), and use one PNG as a supporting visual. Most "documentary-feel" but reduces the visual punch the placeholder was reaching for.

The planner should ask the user which they prefer, OR pick the one that best fits the post's pacing (probably #2 — least friction, two figures one after the other tells the story without composition work). The REQUIREMENTS.md spec for VIS-03 should be updated to match whichever shape lands.

</open_questions_for_plan_phase>
