# Tasks: #24 Optional announcement banner

Requirements source: AC-1 to AC-12 in the spec stage comment on issue #24 (`spec.md` is not on the branch). See `plan.md`.

## Phase 1: Setup and tests first

- [ ] T001 [AC-1] site.config.json — create at repo root with `bannerEnabled: false`, `bannerText` and `bannerLink` keys present
- [ ] T002 [P] [AC-2] /tmp/banner-check.sh (not committed) — script: for each config variant in the plan's test table, write `site.config.json`, run `npm run build`, start `node ./dist/server/entry.mjs`, fetch `/` and `/thank-you`, print PASS/FAIL per expectation, stop the server, restore the file with `git checkout site.config.json`

## Phase 2: Implementation

- [ ] T003 [AC-3] [AC-4] [AC-5] [AC-8] src/lib/site-config.ts — `getBanner()`: `import.meta.glob('/site.config.json', { eager: true, query: '?raw', import: 'default' })`, `JSON.parse` in try/catch, object check, `bannerEnabled === true`, trimmed text 1-120 chars, `bannerLink` kept only for `http:`/`https:` URLs
- [ ] T004 [AC-2] [AC-6] [AC-7] src/components/Banner.astro — render nothing for `null`; otherwise `<div class="banner" data-banner>` with escaped `{text}`, wrapped in `<a href>` when `href` is set; scoped styles with no `transition`/`animation`; no button or script
- [ ] T005 [AC-2] [AC-11] src/pages/index.astro — import `Banner` and place `<Banner />` between `</nav>` and `<section class="hero">`; leave `src/pages/thank-you.astro` and `src/layouts/Layout.astro` unchanged
- [ ] T006 [AC-2] [AC-3] [AC-4] [AC-5] [AC-6] [AC-8] [AC-11] /tmp/banner-check.sh — run the variant script; fix failures (first check: glob path root resolves, `{bad json` keeps the build green)

## Phase 3: Polish

- [ ] T007 [P] [AC-10] README.md — add "Announcement banner" section (file location, three keys with type, default, limits, http/https rule, rebuild note); add `site.config.json`, `src/lib/site-config.ts`, `src/components/Banner.astro` to "Structure"
- [ ] T008 [P] [AC-7] [AC-9] src/components/Banner.astro, package.json — `grep -nE 'button|script|transition|animation' src/components/Banner.astro` prints nothing; `git diff main -- package.json package-lock.json` is empty
- [ ] T009 [AC-1] [AC-12] quality gate and smoke test — restore committed `site.config.json`, `npm ci`, `npm run build` (exit 0), `npm start` and `GET /` returns 200 with the hero and no `data-banner`; `git status --short` shows only the planned files
