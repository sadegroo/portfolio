---
phase: 01-foundation
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - hugo.toml
  - .gitignore
  - .gitmodules
  - themes/PaperMod
  - archetypes/default.md
autonomous: false
requirements:
  - TOOL-01
  - TOOL-02
  - SCAF-01
  - SCAF-02
  - SCAF-03
  - SCAF-04
  - HYG-01
  - HYG-02
  - HYG-03

user_setup:
  - service: chocolatey
    why: "Hugo extended install on Windows requires Chocolatey running in an elevated shell"
    env_vars: []
    dashboard_config:
      - task: "Open an elevated (Run as Administrator) PowerShell or Git Bash session before running `choco install hugo-extended -y`"
        location: "Windows Start menu → right-click PowerShell → Run as administrator"

must_haves:
  truths:
    - "`hugo version` reports an extended build at v0.120 or later"
    - "Running `git diff HEAD -- README.md LICENSE` after scaffold is empty (load-bearing files preserved byte-for-byte)"
    - "The repo contains a Hugo site layout (hugo.toml, archetypes/, content/, ...) at the working copy root"
    - "PaperMod is checked out at themes/PaperMod and registered as a submodule with a non-detached SHA visible in `git submodule status`"
    - "`hugo.toml` declares title=Sadegroo, languageCode=en, theme=PaperMod, JSON output on home, tag taxonomy, About in main menu, and a commented TODO for baseURL"
    - "`.gitignore` excludes public/, resources/, and .hugo_build.lock"
  artifacts:
    - path: "hugo.toml"
      provides: "Hugo site configuration with PaperMod search/tags/about-menu enabled"
      contains: 'theme = "PaperMod"'
    - path: ".gitignore"
      provides: "Excludes Hugo build artifacts from version control"
      contains: "public/"
    - path: ".gitmodules"
      provides: "Registers PaperMod as a submodule"
      contains: "themes/PaperMod"
    - path: "themes/PaperMod"
      provides: "PaperMod theme working tree (submodule checkout)"
    - path: "archetypes/default.md"
      provides: "Evidence that `hugo new site` ran successfully"
  key_links:
    - from: "hugo.toml"
      to: "themes/PaperMod"
      via: "theme = \"PaperMod\""
      pattern: 'theme\s*=\s*"PaperMod"'
    - from: ".gitmodules"
      to: "themes/PaperMod"
      via: "submodule path entry"
      pattern: 'path\s*=\s*themes/PaperMod'
    - from: "hugo.toml"
      to: "PaperMod search index"
      via: "outputs.home includes JSON"
      pattern: 'JSON'
---

<objective>
Stand up the Hugo + PaperMod foundation in the existing `C:/Users/u0130154/repos/portfolio` working copy without disturbing the load-bearing `README.md` and `LICENSE`.

Purpose: Phase 1 of the Sadegroo Portfolio milestone. Everything downstream (content seeding, CI, deploy) depends on a clean themed Hugo skeleton existing at the repo root with hygiene rules and submodule wiring already in place.

Output:
- Hugo extended toolchain present on `PATH`
- Hugo site layout scaffolded in-place (archetypes/, content/, data/, layouts/, static/, themes/, hugo.toml)
- PaperMod theme attached as a git submodule under `themes/PaperMod`
- `hugo.toml` written with documented PaperMod-aware config and a `# TODO` baseURL marker
- `.gitignore` excluding Hugo build artifacts
- README.md and LICENSE byte-identical to pre-scaffold baseline
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/REQUIREMENTS.md
@.planning/ROADMAP.md
@.planning/phases/01-foundation/01-CONTEXT.md
@README.md
@LICENSE

<environment>
- Working directory: `C:/Users/u0130154/repos/portfolio` (Git Bash; PowerShell available)
- Branch: `main`, working tree clean apart from `.planning/` artifacts
- No remote git operations permitted (no push, no remote API calls). Submodule add is local-only and uses HTTPS URL.
- Chocolatey installs require an elevated shell. If not already elevated, request the user run the install command themselves and resume execution after they confirm.
</environment>

<baseline_invariants>
- `README.md` SHA at HEAD must match SHA after every step. Verify with `git diff HEAD -- README.md` (must be empty).
- `LICENSE` SHA at HEAD must match SHA after every step. Verify with `git diff HEAD -- LICENSE` (must be empty).
- `.planning/` is out of scope for this plan — do not edit any file under `.planning/` other than what `/gsd` tooling writes automatically.
</baseline_invariants>
</context>

<tasks>

<task type="checkpoint:human-action" gate="blocking">
  <name>Task 1: Ensure Hugo extended is installed (TOOL-01, TOOL-02)</name>
  <what-built>
    Pre-flight check for the Hugo toolchain. The executor will run the version probe automatically; the human-action checkpoint only fires if installation is required and the current shell is not elevated.
  </what-built>
  <action>
    Step 1 — Probe for Hugo extended (no elevation required):
    ```bash
    hugo version
    ```
    Pass condition: stdout matches BOTH of the following regexes:
      - `v0\.(12[0-9]|1[3-9][0-9]|[2-9][0-9]{2,})` (v0.120 or later)
      - `extended` (case-insensitive)
    If both match → record the version string and SKIP straight to Task 2 with no checkpoint.

    Step 2 — If the probe fails (Hugo missing OR not extended OR version &lt; 0.120):
    Attempt the install in a non-interactive fashion from the current shell:
    ```bash
    choco install hugo-extended -y --no-progress
    ```
    If `choco` reports "elevated permissions are required" or exits non-zero with an access-denied error, STOP and surface this checkpoint to the user.

    Step 3 — Re-probe `hugo version` after install. The same pass condition from Step 1 must hold. If it still fails, surface the error and stop.

    Notes:
    - This task does NOT modify any tracked files; it only mutates system state (PATH/installed software).
    - Do not call `choco upgrade hugo-extended` if the existing install already passes Step 1 — leave the user's toolchain alone.
  </action>
  <how-to-verify>
    Only relevant if the checkpoint actually fires (i.e. install needed AND current shell unelevated):

    1. Open an **elevated** shell (PowerShell or Git Bash → "Run as administrator").
    2. Run: `choco install hugo-extended -y`
    3. Close that shell, return to the regular shell, and run: `hugo version`
    4. Expected outcome: output contains a version `v0.120` or later AND the word `extended`.
    5. Reply `installed` (or paste the `hugo version` output) to resume.
  </how-to-verify>
  <resume-signal>Type `installed` or paste `hugo version` output. If you want to skip the install and exit, type `abort`.</resume-signal>
  <verify>
    <automated>hugo version | grep -E 'v0\.(12[0-9]|1[3-9][0-9]|[2-9][0-9]{2,})' &amp;&amp; hugo version | grep -i extended</automated>
  </verify>
  <done>`hugo version` prints a version `v0.120` or later AND contains the word `extended` (case-insensitive). No tracked files have been modified by this task.</done>
</task>

<task type="auto" tdd="false">
  <name>Task 2: Scaffold Hugo site in-place and attach PaperMod submodule (SCAF-01, SCAF-02, HYG-02)</name>
  <files>archetypes/default.md, content/, data/, layouts/, static/, themes/PaperMod, .gitmodules, hugo.toml</files>
  <action>
    All steps run from `C:/Users/u0130154/repos/portfolio` (the repo root). Use Git Bash.

    Step 1 — Snapshot the load-bearing files (sanity-check baseline before any mutation):
    ```bash
    git rev-parse HEAD:README.md HEAD:LICENSE
    sha256sum README.md LICENSE
    ```
    Record both outputs in a shell variable or scratch note for comparison after scaffold.

    Step 2 — Scaffold the Hugo site in-place. `--force` is REQUIRED because the directory is non-empty (it contains `README.md`, `LICENSE`, `.git/`, `.planning/`, `CLAUDE.md`):
    ```bash
    hugo new site . --force
    ```
    Expected stdout includes a "Congratulations!" line. Hugo creates: `archetypes/`, `assets/` (sometimes), `content/`, `data/`, `layouts/`, `static/`, `themes/`, and a `hugo.toml` (or `hugo.yaml` depending on Hugo version — if Hugo emits `hugo.yaml` instead, delete it and let Task 3 write `hugo.toml` from scratch).

    Step 3 — Immediately verify README.md and LICENSE are byte-identical to pre-scaffold (HYG-02):
    ```bash
    git diff HEAD -- README.md LICENSE
    ```
    Expected: empty output (zero diff). If non-empty, STOP and report the diff — `hugo new site` is not supposed to touch these files; if it did, restore them via `git checkout HEAD -- README.md LICENSE` before proceeding.

    Step 4 — Add the PaperMod theme as a git submodule (SCAF-02). HTTPS URL only; no SSH, no push:
    ```bash
    git submodule add https://github.com/adityatelange/hugo-PaperMod themes/PaperMod
    ```
    Expected: `.gitmodules` is created (or appended) and `themes/PaperMod/` is populated with PaperMod's working tree at the latest default-branch commit. No network operation other than the clone itself; do NOT run `git push` or `git submodule update --remote`.

    Step 5 — Capture the submodule's checked-out SHA for the SUMMARY (HYG-03 evidence):
    ```bash
    git submodule status themes/PaperMod
    ```
    Expected: a single line beginning with a non-detached SHA (a leading space, NOT `-` or `+`) followed by `themes/PaperMod` and a `(tag-or-branch)` annotation.

    Step 6 — Hugo's default scaffold output for the config file. Hugo 0.120+ writes either `hugo.toml` or `hugo.yaml` depending on version. If a `hugo.yaml` was created, delete it now (`rm hugo.yaml`) — Task 3 owns writing `hugo.toml` from scratch. If `hugo.toml` was created, leave it; Task 3 will overwrite it with the documented version.

    Notes / failure modes:
    - If `hugo new site . --force` errors with "directory not empty" despite `--force`, double-check Hugo version (must be ≥ 0.120) and re-run.
    - Do NOT `git add` or commit anything in this task — the orchestrator/`gsd-sdk query commit` handles staging in the post-plan commit step. Leaving everything unstaged also makes the verification in Task 4 cleaner.
  </action>
  <verify>
    <automated>test -f archetypes/default.md &amp;&amp; test -d themes/PaperMod &amp;&amp; test -f .gitmodules &amp;&amp; grep -q 'path = themes/PaperMod' .gitmodules &amp;&amp; git submodule status themes/PaperMod | grep -E '^[[:space:]][0-9a-f]{40} themes/PaperMod' &amp;&amp; [ -z "$(git diff HEAD -- README.md LICENSE)" ]</automated>
  </verify>
  <done>
    - `archetypes/default.md` exists (proof Hugo scaffold ran)
    - `themes/PaperMod/` is populated (non-empty directory)
    - `.gitmodules` registers `themes/PaperMod` with the upstream URL
    - `git submodule status themes/PaperMod` shows a 40-char SHA prefixed with a SPACE (not `-` meaning uninitialized, not `+` meaning out-of-sync)
    - `git diff HEAD -- README.md LICENSE` is empty
  </done>
</task>

<task type="auto" tdd="false">
  <name>Task 3: Write hugo.toml and .gitignore with documented PaperMod config (SCAF-03, SCAF-04, HYG-01)</name>
  <files>hugo.toml, .gitignore</files>
  <action>
    Step 1 — Overwrite (or create) `hugo.toml` at the repo root with EXACTLY the following content. The file is heavily commented because it is the user-facing config and will be edited by hand later (per SCAF-03 "documented"). Use the Write tool, not heredoc.

    ```toml
    # ============================================================================
    # Sadegroo Portfolio — Hugo site configuration
    # ============================================================================
    # Theme: PaperMod (git submodule at themes/PaperMod)
    # Docs:  https://github.com/adityatelange/hugo-PaperMod/wiki
    # ----------------------------------------------------------------------------

    # TODO(baseURL): Set to the final published URL once GitHub Pages is enabled.
    #   - For default GH Pages on a user/project repo: "https://sadegroo.github.io/"
    #   - For a custom domain: e.g. "https://sadegroo.dev/"
    # Leave commented out until decided — Hugo will fall back to "/" for local dev.
    # baseURL = "https://sadegroo.github.io/"

    title        = "Sadegroo"
    languageCode = "en"
    theme        = "PaperMod"

    # Enable PaperMod's client-side search by emitting a JSON index for the home page.
    # PaperMod's search template (layouts/_default/search.html in the theme) reads /index.json.
    [outputs]
      home = ["HTML", "RSS", "JSON"]

    # Tag taxonomy is on by default in Hugo, but declare it explicitly so it's
    # discoverable and so future taxonomies (categories, series) slot in cleanly.
    [taxonomies]
      tag = "tags"

    # ----------------------------------------------------------------------------
    # Main navigation menu
    # ----------------------------------------------------------------------------
    # Lower `weight` = further left. Posts is implicit via PaperMod's defaults,
    # but we surface About explicitly per the v1 brief (SCAF-04).
    # The /search/ entry is wired up by PaperMod when JSON output is enabled.
    [[menu.main]]
      identifier = "about"
      name       = "About"
      url        = "/about/"
      weight     = 10

    [[menu.main]]
      identifier = "posts"
      name       = "Posts"
      url        = "/posts/"
      weight     = 20

    [[menu.main]]
      identifier = "search"
      name       = "Search"
      url        = "/search/"
      weight     = 30

    # ----------------------------------------------------------------------------
    # PaperMod theme parameters
    # ----------------------------------------------------------------------------
    [params]
      # Enable PaperMod's built-in Fuse.js search (requires the JSON output above).
      ShowShareButtons    = false
      ShowReadingTime     = true
      ShowPostNavLinks    = true
      ShowBreadCrumbs     = true
      ShowCodeCopyButtons = true

      [params.fuseOpts]
        isCaseSensitive  = false
        shouldSort       = true
        location         = 0
        distance         = 1000
        threshold        = 0.4
        minMatchCharLength = 0
        keys             = ["title", "permalink", "summary", "content"]
    ```

    Step 2 — Overwrite (or create) `.gitignore` at the repo root. If a `.gitignore` already exists, REPLACE it with the content below (Hugo did not ship one as part of `hugo new site`; if it did, we still want exactly these rules):

    ```gitignore
    # Hugo build output — generated by `hugo` / `hugo --minify`; never committed.
    public/

    # Hugo's per-build cache for processed assets (images, SCSS, etc.).
    resources/

    # Hugo build lock file.
    .hugo_build.lock
    ```

    Step 3 — Spot-check that the files were written and key invariants hold:
    ```bash
    grep -E '^title\s*=\s*"Sadegroo"' hugo.toml
    grep -E '^theme\s*=\s*"PaperMod"' hugo.toml
    grep -E '^languageCode\s*=\s*"en"' hugo.toml
    grep -E 'baseURL' hugo.toml | grep -E '^\s*#'   # must be commented
    grep -E '"JSON"' hugo.toml
    grep -E '^\[\[menu.main\]\]' hugo.toml | wc -l  # must be >= 1 (About entry)
    grep -E '^public/$' .gitignore
    grep -E '^resources/$' .gitignore
    grep -E '^\.hugo_build\.lock$' .gitignore
    ```
    Each command must succeed (exit 0) and the menu count must be ≥ 1. If any check fails, STOP and report.

    Step 4 — Re-confirm README.md and LICENSE have not drifted:
    ```bash
    git diff HEAD -- README.md LICENSE
    ```
    Must be empty.
  </action>
  <verify>
    <automated>grep -qE '^title[[:space:]]*=[[:space:]]*"Sadegroo"' hugo.toml &amp;&amp; grep -qE '^theme[[:space:]]*=[[:space:]]*"PaperMod"' hugo.toml &amp;&amp; grep -qE '^languageCode[[:space:]]*=[[:space:]]*"en"' hugo.toml &amp;&amp; grep -qE '^[[:space:]]*#.*baseURL' hugo.toml &amp;&amp; grep -q '"JSON"' hugo.toml &amp;&amp; grep -qE '^\[\[menu\.main\]\]' hugo.toml &amp;&amp; grep -qE '^public/$' .gitignore &amp;&amp; grep -qE '^resources/$' .gitignore &amp;&amp; grep -qE '^\.hugo_build\.lock$' .gitignore &amp;&amp; [ -z "$(git diff HEAD -- README.md LICENSE)" ]</automated>
  </verify>
  <done>
    - `hugo.toml` exists with title=Sadegroo, languageCode=en, theme=PaperMod, JSON output on home, tag taxonomy, ≥1 main menu entry (About), and baseURL present only as a commented TODO line
    - `.gitignore` excludes exactly `public/`, `resources/`, `.hugo_build.lock`
    - README.md and LICENSE remain byte-identical to HEAD
  </done>
</task>

<task type="auto" tdd="false">
  <name>Task 4: Phase 1 verification sweep — REQ-ID-mapped invariants (HYG-02, HYG-03 + sweep of all in-scope REQs)</name>
  <files></files>
  <action>
    This task runs ONLY verification commands. It must NOT mutate any tracked file. If any check fails, stop and surface the failure with the offending command and its output.

    Run each block in order. Each `&amp;&amp;` chain must exit 0.

    Block A — TOOL-01 / TOOL-02:
    ```bash
    hugo version | grep -E 'v0\.(12[0-9]|1[3-9][0-9]|[2-9][0-9]{2,})'
    hugo version | grep -i extended
    ```

    Block B — SCAF-01 (Hugo site layout exists in-place):
    ```bash
    test -f archetypes/default.md
    test -d content
    test -d data
    test -d layouts
    test -d static
    test -d themes
    ```

    Block C — SCAF-02 + HYG-03 (PaperMod submodule wired and pinned to a non-detached SHA):
    ```bash
    test -f .gitmodules
    grep -q 'path = themes/PaperMod' .gitmodules
    grep -q 'url = https://github.com/adityatelange/hugo-PaperMod' .gitmodules
    test -d themes/PaperMod
    test -f themes/PaperMod/theme.toml   # PaperMod ships a theme.toml — proves checkout populated
    git submodule status themes/PaperMod | grep -E '^[[:space:]][0-9a-f]{40} themes/PaperMod'
    ```
    Note: the leading SPACE in the regex is intentional — it distinguishes a properly-checked-out submodule from `-SHA` (uninitialized) or `+SHA` (out-of-sync).

    Block D — SCAF-03 (hugo.toml has required keys, baseURL is a commented TODO):
    ```bash
    grep -qE '^title[[:space:]]*=[[:space:]]*"Sadegroo"' hugo.toml
    grep -qE '^languageCode[[:space:]]*=[[:space:]]*"en"' hugo.toml
    grep -qE '^theme[[:space:]]*=[[:space:]]*"PaperMod"' hugo.toml
    # baseURL must appear ONLY on commented lines (lines beginning with optional whitespace then `#`).
    # Filter comments out and confirm no uncommented baseURL line exists.
    [ "$(grep -v '^[[:space:]]*#' hugo.toml | grep -c baseURL)" = "0" ]
    # And confirm at least one commented TODO line mentions baseURL.
    grep -qE '^[[:space:]]*#.*baseURL' hugo.toml
    ```

    Block E — SCAF-04 (PaperMod features enabled):
    ```bash
    grep -q '"JSON"' hugo.toml          # search index output
    grep -qE '^\[taxonomies\]' hugo.toml
    grep -qE '^[[:space:]]*tag[[:space:]]*=' hugo.toml
    grep -qE '^\[\[menu\.main\]\]' hugo.toml
    # Confirm the About menu entry specifically (case-insensitive name match, allow either ordering of name/identifier).
    awk 'BEGIN{RS="\\[\\[menu.main\\]\\]"} /name[[:space:]]*=[[:space:]]*"About"/' hugo.toml | grep -q 'About'
    ```

    Block F — HYG-01 (gitignore excludes Hugo build artifacts):
    ```bash
    test -f .gitignore
    grep -qE '^public/$' .gitignore
    grep -qE '^resources/$' .gitignore
    grep -qE '^\.hugo_build\.lock$' .gitignore
    ```

    Block G — HYG-02 (README + LICENSE byte-identical to HEAD baseline):
    ```bash
    [ -z "$(git diff HEAD -- README.md LICENSE)" ]
    git ls-files --error-unmatch README.md LICENSE   # both still tracked
    ```

    Block H — Sanity: nothing under `.planning/` was mutated by this plan (other than what `/gsd-plan-phase` writes into `.planning/phases/01-foundation/`):
    ```bash
    # The only acceptable changes under .planning/ are inside phases/01-foundation/.
    # Anything else under .planning/ being modified would be a scope leak.
    git status --porcelain .planning/ | grep -vE '^.. \.planning/phases/01-foundation/' | grep -E '^.. \.planning/' &amp;&amp; exit 1 || true
    ```

    Final step — print a compact verification report:
    ```bash
    echo "=== Phase 1 Foundation: verification summary ==="
    hugo version
    echo "--- submodule ---"
    git submodule status themes/PaperMod
    echo "--- README/LICENSE drift ---"
    git diff --stat HEAD -- README.md LICENSE || true
    echo "--- staged status ---"
    git status --short
    ```
  </action>
  <verify>
    <automated>hugo version | grep -i extended &amp;&amp; test -f archetypes/default.md &amp;&amp; test -f themes/PaperMod/theme.toml &amp;&amp; git submodule status themes/PaperMod | grep -E '^[[:space:]][0-9a-f]{40} themes/PaperMod' &amp;&amp; grep -qE '^theme[[:space:]]*=[[:space:]]*"PaperMod"' hugo.toml &amp;&amp; [ "$(grep -v '^[[:space:]]*#' hugo.toml | grep -c baseURL)" = "0" ] &amp;&amp; grep -q '"JSON"' hugo.toml &amp;&amp; grep -qE '^public/$' .gitignore &amp;&amp; [ -z "$(git diff HEAD -- README.md LICENSE)" ]</automated>
  </verify>
  <done>
    All Blocks A–H pass with exit 0. The compact verification report is printed to stdout for inclusion in the SUMMARY.
  </done>
</task>

</tasks>

<verification>
## Phase 1 REQ-ID → Verification Map

Every in-scope requirement maps to at least one explicit check in Task 4 (the verification sweep). Tasks 1–3 produce the artifacts; Task 4 proves them.

| REQ-ID | Verification |
|--------|--------------|
| TOOL-01 | Task 1 probe + Task 4 Block A: `hugo version` matches `v0\.(12[0-9]\|1[3-9][0-9]\|[2-9][0-9]{2,})` AND contains `extended` |
| TOOL-02 | Task 1 install path: `choco install hugo-extended -y` runs (in elevated shell, via human-action checkpoint if needed); only triggered if TOOL-01 probe fails. Verified by re-running TOOL-01 check. |
| SCAF-01 | Task 4 Block B: `archetypes/default.md`, `content/`, `data/`, `layouts/`, `static/`, `themes/` all exist at repo root + Block G: README/LICENSE diff against HEAD is empty |
| SCAF-02 | Task 4 Block C: `.gitmodules` registers `themes/PaperMod` with upstream URL, `themes/PaperMod/theme.toml` exists, submodule status shows non-detached 40-char SHA |
| SCAF-03 | Task 4 Block D: `hugo.toml` has title=Sadegroo, languageCode=en, theme=PaperMod; `baseURL` appears ONLY on commented lines AND at least one commented TODO line mentions it |
| SCAF-04 | Task 4 Block E: `hugo.toml` includes `"JSON"` (search), `[taxonomies]` with `tag = ...`, ≥1 `[[menu.main]]` block, About entry present by name |
| HYG-01 | Task 4 Block F: `.gitignore` contains exact lines `public/`, `resources/`, `.hugo_build.lock` |
| HYG-02 | Task 4 Block G: `git diff HEAD -- README.md LICENSE` is empty AND both files still tracked |
| HYG-03 | Task 4 Block C: `git submodule status themes/PaperMod` line begins with a SPACE then a 40-char SHA (proves submodule is initialized, checked out, and on a clean SHA — not detached/uninitialized/out-of-sync) |

## Manual confirmation steps (executor reports these in SUMMARY)
- The exact `hugo version` string captured (for use by Phase 3 CI version pinning)
- The PaperMod submodule SHA captured from `git submodule status themes/PaperMod` (for the SUMMARY's "tech stack pins" section)
</verification>

<success_criteria>
Phase 1 is complete when:
1. `hugo version` reports an extended build at v0.120 or later
2. The repo contains a Hugo site layout at the working copy root (`archetypes/`, `content/`, `data/`, `layouts/`, `static/`, `themes/`)
3. `themes/PaperMod` is a populated git submodule with a non-detached SHA, registered in `.gitmodules`
4. `hugo.toml` declares title="Sadegroo", languageCode="en", theme="PaperMod", JSON home output, tag taxonomy, About in main menu, and `baseURL` present ONLY as a commented TODO
5. `.gitignore` excludes `public/`, `resources/`, and `.hugo_build.lock`
6. `git diff HEAD -- README.md LICENSE` is empty (load-bearing files preserved byte-for-byte)
7. No file under `.planning/` was modified by this plan outside `.planning/phases/01-foundation/`
</success_criteria>

<output>
After completion, create `.planning/phases/01-foundation/01-01-SUMMARY.md` capturing:
- The exact `hugo version` string
- The PaperMod submodule SHA (from `git submodule status themes/PaperMod`)
- The list of files created/modified by this plan (from `git status --short`)
- Any deviations from the plan and their rationale
- Confirmation of REQ-IDs closed: TOOL-01, TOOL-02, SCAF-01, SCAF-02, SCAF-03, SCAF-04, HYG-01, HYG-02, HYG-03
</output>
