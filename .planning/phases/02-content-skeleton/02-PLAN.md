---
phase: 02-content-skeleton
plan: 02
type: execute
wave: 1
depends_on: ["01-foundation/01"]
files_modified:
  - content/posts/_index.md
  - content/projects/_index.md
  - content/about.md
  - content/posts/bldc-pendulum.md
autonomous: true
requirements:
  - CONT-01
  - CONT-02
  - CONT-03
  - CONT-04
must_haves:
  truths:
    - "content/posts/ exists as a Hugo section (has _index.md)"
    - "content/projects/ exists as a Hugo section (has _index.md)"
    - "content/about.md exists with `url = \"/about/\"` matching Phase 1's main-menu wiring"
    - "content/posts/bldc-pendulum.md has the exact required front matter and the five required section headings"
---

<objective>
Seed the content scaffolding so PaperMod has something to render. No template/layout work; placeholder content under each heading instructs the user what to write later.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Create section indexes (CONT-01, CONT-02)</name>
  <files>content/posts/_index.md, content/projects/_index.md</files>
  <action>
    Write `content/posts/_index.md` and `content/projects/_index.md` as TOML-front-matter branch-bundle indexes. Without an `_index.md`, an empty section directory is invisible to PaperMod's list templates.
  </action>
  <done>
    - `test -d content/posts && test -f content/posts/_index.md`
    - `test -d content/projects && test -f content/projects/_index.md`
  </done>
</task>

<task type="auto">
  <name>Task 2: Create about.md placeholder (CONT-03)</name>
  <files>content/about.md</files>
  <action>
    Write `content/about.md` with `url = "/about/"` (matches Phase 1 main-menu entry) and a placeholder body of HTML-comment writing prompts the user can replace.
  </action>
  <done>
    - `test -f content/about.md && grep -q 'url = "/about/"' content/about.md`
  </done>
</task>

<task type="auto">
  <name>Task 3: Create BLDC pendulum draft (CONT-04)</name>
  <files>content/posts/bldc-pendulum.md</files>
  <action>
    Write `content/posts/bldc-pendulum.md` with EXACTLY the front matter required by CONT-04:
      - `title = "Inverted Pendulum Stabilisation with BLDC Motor and STM32"`
      - `tags = ["embedded", "control", "STM32", "BLDC"]`
      - `draft = true`
    And body section headings `## Overview`, `## Hardware Setup`, `## Control Architecture`, `## Results`, `## Source Code`. Under each heading: an HTML-comment block listing what the user should fill in, plus a one-line "Placeholder: …" sentence so the page is non-empty when rendered with `--buildDrafts`.
  </action>
  <done>
    - `grep -qE '^title = "Inverted Pendulum Stabilisation with BLDC Motor and STM32"$' content/posts/bldc-pendulum.md`
    - `grep -qE '^draft = true$' content/posts/bldc-pendulum.md`
    - `grep -qE 'tags = \["embedded", "control", "STM32", "BLDC"\]' content/posts/bldc-pendulum.md`
    - All five section headings present (`## Overview`, `## Hardware Setup`, `## Control Architecture`, `## Results`, `## Source Code`)
  </done>
</task>

<task type="auto">
  <name>Task 4: Verification sweep</name>
  <action>
    Re-run the per-task `done` checks AND confirm `git diff HEAD -- README.md LICENSE` is still empty (HYG-02 invariant must survive every phase).
  </action>
</task>

</tasks>

<verification>

| REQ-ID | Check |
|--------|-------|
| CONT-01 | `content/posts/_index.md` exists |
| CONT-02 | `content/projects/_index.md` exists |
| CONT-03 | `content/about.md` exists with `url = "/about/"` |
| CONT-04 | `content/posts/bldc-pendulum.md` has required front matter and 5 section headings |

</verification>
