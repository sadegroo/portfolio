<!-- GSD:project-start source:PROJECT.md -->
## Project

**Sadegroo Portfolio**

A personal portfolio and project blog for Sander ("sadegroo") covering embedded systems, control engineering, 3D printing, and home automation. Built as a static site with Hugo + the PaperMod theme, deployed to GitHub Pages from `github.com/sadegroo/portfolio` on push to `main`.

**Core Value:** Pushing to `main` publishes the site at `sadegroo.github.io` — zero manual build steps, zero hosting cost. Everything else (themes, search, tags) is in service of that one loop working reliably.

### Constraints

- **Tech stack**: Hugo extended (≥ v0.120), PaperMod theme (git submodule), GitHub Actions, GitHub Pages → `gh-pages` branch via `peaceiris/actions-gh-pages`. Brief is prescriptive; no stack debate.
- **Platform**: Windows 11 dev environment. Package install via Chocolatey (`choco install hugo-extended`). No WSL/Linux assumptions.
- **Repo state**: README.md and LICENSE on the remote are load-bearing — must be preserved verbatim through scaffolding (`hugo new site . --force` must not clobber them).
- **No remote git ops**: Do not push, do not enable Pages in GitHub settings, do not create branches on remote. User reviews locally and pushes manually.
- **Cost**: Free tier only — GitHub Pages + Actions on a public repo. No paid hosting, no paid CI minutes.
<!-- GSD:project-end -->

<!-- GSD:stack-start source:STACK.md -->
## Technology Stack

Technology stack not yet documented. Will populate after codebase mapping or first phase.
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:skills-start source:skills/ -->
## Project Skills

No project skills found. Add skills to any of: `.claude/skills/`, `.agents/skills/`, `.cursor/skills/`, `.github/skills/`, or `.codex/skills/` with a `SKILL.md` index file.
<!-- GSD:skills-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
