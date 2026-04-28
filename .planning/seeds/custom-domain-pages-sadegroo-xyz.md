---
seed: custom-domain
status: parked
parked_at: 2026-04-28
trigger: "User decides to set up DNS for sadegroo.xyz, OR is ready to publish under the branded URL"
priority: low
estimated_effort: ~30 min (mostly waiting on DNS propagation + GitHub cert provisioning)
---

# Seed: Switch portfolio to custom subdomain `pages.sadegroo.xyz`

## Why parked

User owns `sadegroo.xyz` but has not configured DNS for it yet (as of 2026-04-28). For the time being the portfolio publishes at the default GitHub Pages project URL `https://sadegroo.github.io/portfolio/` — which works and validates the CI pipeline end-to-end without DNS in the mix.

## When to surface

When the user:
- Mentions setting up DNS for `sadegroo.xyz`, or
- Mentions any subdomain plan for that domain, or
- Says they're ready to switch the portfolio to its branded URL.

## What to do (the actual work)

**Total time:** ~30 min, mostly waiting on DNS + cert provisioning.

### 1. DNS — at the registrar holding `sadegroo.xyz`

Add one record:

| Type | Name | Value | TTL |
|------|------|-------|-----|
| CNAME | `pages` | `sadegroo.github.io.` | 1h |

Note the trailing dot (BIND syntax). Verify with `dig +short pages.sadegroo.xyz` until it returns `sadegroo.github.io`.

### 2. Repo changes (one commit)

- Create `static/CNAME` containing the single line: `pages.sadegroo.xyz`
  (Hugo copies it to `public/CNAME` on every build, so it survives each deploy. Without this in `static/`, GitHub's auto-CNAME on the `gh-pages` branch would be wiped by the next CI run.)
- Edit `hugo.toml`: change `baseURL = "https://sadegroo.github.io/portfolio/"` → `baseURL = "https://pages.sadegroo.xyz/"`
- Commit, push.

### 3. GitHub repo settings

- Settings → Pages → Custom domain → `pages.sadegroo.xyz` → Save
- Wait for the green "DNS check successful" tick (~1–10 min)
- Tick "Enforce HTTPS" once the cert provisions (~5 min after the green tick)

### 4. Verify

- `https://pages.sadegroo.xyz/` loads the site, no cert warnings
- Browser DevTools → no 404s on CSS/JS (asset paths now under the new baseURL)
- Old URL `https://sadegroo.github.io/portfolio/` 301-redirects to the new one (GitHub does this automatically once a custom domain is set)

## Related context

- This work was planned during the v1 milestone but explicitly deferred (see PROJECT.md "Out of Scope": custom domain / DNS / baseURL finalization).
- POL-02 in REQUIREMENTS.md v2 covers the baseURL change; this seed extends it to the full custom-domain switchover.
- Earlier conversation already walked through staged-rollout reasoning (validate project URL first, then add custom domain) — that ordering is what landed us here.

## Risks / gotchas

- HTTPS enforcement requires the cert to provision first. If you tick "Enforce HTTPS" too early the toggle silently does nothing; come back in 5 min.
- Don't put `https://` or trailing slash in `static/CNAME` — just `pages.sadegroo.xyz` on its own line.
- If you ever delete the `static/CNAME`, the next deploy will drop the custom-domain wiring and `pages.sadegroo.xyz` will start serving GitHub's default 404 page.
