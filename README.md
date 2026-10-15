# agent-sandbox

[![CI](https://github.com/kinged007/agent-sandbox/actions/workflows/ci.yml/badge.svg)](https://github.com/kinged007/agent-sandbox/actions/workflows/ci.yml)
[![Version](https://img.shields.io/badge/version-0.0.1-blue)](./package.json)

Public showcase for autonomous coding agents — [sortie-loop](https://github.com/kinged007/sortie-loop) works real GitHub issues here. Merged PRs and review trails stay visible.

This repo hosts an [Astro](https://astro.build) SSR landing page ("Agent-Led Dev") that agents modify end-to-end via Bernstein webhooks. Ideal for demonstrating autonomous delivery on a real codebase without risking product repos.

![Demo](./docs/screenshot.png)
> Screenshot to be added — run `npm run dev` and capture the landing page hero. Replace `docs/screenshot.png` when available.

## Install

Requires Node 20+.

```bash
git clone https://github.com/kinged007/agent-sandbox.git
cd agent-sandbox
npm install
```

Copy `.env.example` to `.env` and fill in secrets when running the Bernstein bridge locally.

## Usage

```bash
npm run dev      # local dev server (http://localhost:4321)
npm run build    # production build to dist/
npm run preview  # preview built output
npm start        # run standalone Node server (dist/server/entry.mjs)
```

Label a GitHub issue with `hot-fix`, `bernstein`, `agent-fix`, or `agent-task` to dispatch it to the agent via `.github/workflows/bernstein-hot-fix.yml`.

## How it is tested

- `npm run build` is the build gate (Astro type-check + build).
- CI (`.github/workflows/ci.yml`) runs `npm ci`, `npm run build`, and lint on every push and PR to `main`.
- Add `npm test` / Vitest suites as features grow; update this section and CI when you do.

## Structure

- `src/pages/index.astro` — landing page
- `src/pages/api/contact.ts` — contact form endpoint
- `bernstein.yaml` — Bernstein agent orchestration config
- `scripts/` — Bernstein env patch helpers

## Related

- [sortie-loop](https://github.com/kinged007/sortie-loop) — autonomous GitHub issue loop
- [agent-skill-search](https://github.com/kinged007/agent-skill-search) — skills catalog
