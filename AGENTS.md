# AGENTS.md — agent-sandbox

## Purpose

Public showcase where autonomous agents ([sortie-loop](https://github.com/kinged007/sortie-loop) via Bernstein) work real GitHub issues. Merged PRs and reviews stay visible. The app is an Astro SSR landing page; changes should stay demo-safe.

## How to run checks

```bash
npm ci
npm run build   # Astro build (type-check + build gate)
# npm run check is not defined; `npm run build` is the CI gate
```

CI: `.github/workflows/ci.yml` runs `npm ci` + `npm run build` on push/PR to `main`. The Bernstein dispatch is in `.github/workflows/bernstein-hot-fix.yml` (label-triggered, not a test gate).

## Branch / PR workflow

- Do not push to `main` directly for code changes. Open a branch and a PR.
- PRs targeting `main` must pass CI before merge.
- Issue labels `hot-fix`, `bernstein`, `agent-fix`, `agent-task` trigger Bernstein dispatch — do not abuse.

## Skills and conventions

- Follow existing Astro/TypeScript patterns in `src/`.
- Keep `.env` out of commits; use `.env.example` as the template.
- Do not publish anything derived from the private `tenantflex` org repos. See `docs/03-tenantflex.md` in the profile plan repo for context.

## Deploy

No GitHub Pages deploy is configured for this repo. The Astro build outputs to `dist/` with the Node standalone adapter.
