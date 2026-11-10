# Checklist: #24 plan quality

- [x] CHK001 Is the requirements source stated, given that `spec.md` is missing from the branch? (plan.md and tasks.md headers)
- [x] CHK002 Does every AC (AC-1 to AC-12) appear in at least one task? (AC-1 T001/T009, AC-2 T002/T004/T005/T006, AC-3 T003/T006, AC-4 T003/T006, AC-5 T003/T006, AC-6 T004/T006, AC-7 T004/T008, AC-8 T003/T006, AC-9 T008, AC-10 T007, AC-11 T005/T006, AC-12 T009)
- [x] CHK003 Does every task name an AC or a polish purpose?
- [x] CHK004 Is each AC measurable with a concrete input and an observable result in the test plan?
- [x] CHK005 Does the design keep `npm run build` green for a missing file, malformed JSON, an array and `null` (AC-8)? (glob returns `{}` for a missing file; `?raw` plus try/catch for parse errors; object check)
- [x] CHK006 Is the "valid `bannerText`" rule unambiguous (string, trimmed length 1-120, 120 shown in full)?
- [x] CHK007 Is the "valid `bannerLink`" rule unambiguous, and does an invalid link keep the banner without a link (AC-5)?
- [x] CHK008 Is HTML in `bannerText` escaped rather than rendered (AC-6)?
- [x] CHK009 Does the plan avoid new dependencies and a new test framework (AC-9)?
- [x] CHK010 Is the banner position defined relative to existing markup (between `</nav>` and `<section class="hero">` in `src/pages/index.astro`)?
- [x] CHK011 Is the risk of reused `.btn` styles with `transition` covered (AC-7)?
- [x] CHK012 Are only confirmed paths named? (`src/pages/index.astro`, `src/pages/thank-you.astro`, `src/layouts/Layout.astro`, `README.md`, `package.json`, `package-lock.json` exist; `site.config.json`, `src/lib/site-config.ts`, `src/components/Banner.astro` are new)
- [x] CHK013 Is there a smoke test of the built artifact (`npm start`, `GET /`)?
- [x] CHK014 Is the quality gate taken from the repo (`npm ci`, `npm run build` from `AGENTS.md` and `.github/workflows/ci.yml`)?
- [x] CHK015 Is a safe rollback described?
- [x] CHK016 Does the plan keep scope to the spec (no dismissal, animation, runtime reload, other pages)?
