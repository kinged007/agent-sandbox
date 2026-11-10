# Plan: #24 Optional announcement banner driven by `site.config.json`

**Source of requirements:** `specs/24-announcement-banner/spec.md` is not on branch `auto/24` (the spec stage did not push it). This plan takes the requirements from the issue description and the acceptance criteria AC-1 to AC-12 and clarifications in the spec stage comment on issue #24. Area context is missing: `.agents/areas/` does not exist.

## Approach

- Read the config **at build time** through Vite: `import.meta.glob('/site.config.json', { eager: true, query: '?raw', import: 'default' })`.
  - The glob returns an empty object when the file is missing, so a missing file does not fail the bundle step (AC-8). A static `import config from '../../site.config.json'` would fail.
  - `?raw` returns the file as a string, so malformed JSON does not reach Vite's JSON plugin. The string is parsed with `JSON.parse` inside `try/catch` (AC-8).
- A small module `src/lib/site-config.ts` exports one function `getBanner()` that returns `{ text: string; href?: string } | null`. Validation rules (from the spec clarifications):
  - Parsed value must be a non-null, non-array object; otherwise `null`.
  - `bannerEnabled` must be exactly `true` (`typeof === 'boolean'`); otherwise `null` (AC-3).
  - `bannerText` must be a string; `trim()` result must have length 1 to 120; otherwise `null` (AC-4). The trimmed text is returned.
  - `bannerLink`, if it is a string that `new URL()` parses with protocol `http:` or `https:`, is returned as `href`; any other value is dropped and the banner shows without a link (AC-5).
  - Unknown keys are ignored.
- A component `src/components/Banner.astro` calls `getBanner()` and renders nothing when it returns `null`. Otherwise it renders one element with `class="banner"` and a `data-banner` attribute; the text is a plain Astro expression `{banner.text}`, which Astro escapes (AC-6). With `href` the text is wrapped in `<a href={banner.href}>`. No button, no script, no `transition` or `animation` in its scoped `<style>` (AC-7).
- `src/pages/index.astro` imports `Banner` and places `<Banner />` inside `<main>` between `</nav>` and `<section class="hero">` (AC-2). The nav is `position: sticky`, so the banner sits directly above the hero and scrolls with the page. `thank-you.astro` and `Layout.astro` are not changed (AC-11).
- Commit `site.config.json` at the repo root with `bannerEnabled: false` (AC-1).
- No new dependencies (AC-9). No test framework is added (it would be a new dependency); verification is the build plus requests to the built server per config variant.

## Files to change

| Path | Change |
| --- | --- |
| `site.config.json` (new) | Default config: `{ "bannerEnabled": false, "bannerText": "", "bannerLink": "" }` |
| `src/lib/site-config.ts` (new) | `getBanner()`: raw glob read, safe parse, validation |
| `src/components/Banner.astro` (new) | Banner markup and scoped styles; renders nothing for `null` |
| `src/pages/index.astro` | Import `Banner`, render `<Banner />` between nav and hero |
| `README.md` | New "Announcement banner" section documenting the file and keys; add the new files under "Structure" |

## Data and contract changes

- **Config (public file format):** new `site.config.json` at the repo root. Keys: `bannerEnabled` (boolean, default `false`), `bannerText` (string, 1-120 characters after trim), `bannerLink` (optional absolute `http`/`https` URL). Read at build time; a change takes effect after the next `npm run build`.
- **Dependencies:** none. `package.json` and `package-lock.json` unchanged.
- **Persisted data, APIs, schemas:** none.

## Test plan

The repo has no test runner (`package.json` has no `test` script; README "How it is tested"). Each AC is checked by writing a config variant to `site.config.json`, running `npm run build`, starting `npm start` (`node ./dist/server/entry.mjs`, default port 4321), and fetching `/` and `/thank-you`. A throwaway script in `/tmp` loops over the variants; it is not committed. Restore the committed `site.config.json` afterwards (`git checkout site.config.json`).

Write the variant script first (T002) so each implementation step can be checked against it.

| AC | Variant | Expected |
| --- | --- | --- |
| AC-1, AC-12 | committed file | valid JSON (`node -e "JSON.parse(require('fs').readFileSync('site.config.json','utf8'))"`), build exits 0, `/` has no `data-banner` |
| AC-2 | `{"bannerEnabled":true,"bannerText":"Launch week"}` | `/` has `data-banner` containing `Launch week`, and its offset in the HTML is before `class="hero"` |
| AC-3 | `bannerEnabled` absent, `"true"`, `1` (text valid) | no `data-banner` |
| AC-4 | text `""`, `"   "`, `42`, absent, 121 chars | no `data-banner`; 120 chars → banner contains all 120 characters |
| AC-5 | link `https://example.com` | banner contains `<a href="https://example.com"`; link absent, `"not a url"`, `"javascript:alert(1)"`, `123` → banner present, no `<a` inside it |
| AC-6 | text `"<b>Hi</b>"` | HTML contains `&lt;b&gt;Hi&lt;/b&gt;`, no `<b>Hi</b>` |
| AC-7 | review | `src/components/Banner.astro` contains no `<button`, `<script`, `transition`, `animation` (`grep -nE 'button|script|transition|animation' src/components/Banner.astro` prints nothing) |
| AC-8 | file removed; `{bad json`; `[]`; `null` | build exits 0, `/` returns 200, no `data-banner` |
| AC-9 | `git diff main -- package.json package-lock.json` | empty |
| AC-10 | review README | section names the file, the three keys, types, default, limits, rebuild note |
| AC-11 | `/thank-you` under the AC-2 variant | no `data-banner` |

**Smoke test:** with the committed config, `npm run build && npm start`, then `GET /` returns 200 and the hero markup is present.

## Risks

- **Glob path root.** `import.meta.glob('/site.config.json')` resolves `/` against the Vite root, which Astro sets to the project root. Verify first (T004 under the AC-2 variant). If it does not match, use a relative glob from `src/lib/` (`'../../site.config.json'`).
- **Vite JSON plugin on `?raw`.** If `?raw` still routes through the JSON plugin, malformed JSON would fail the build. The AC-8 `{bad json` variant detects this.
- **SSR caching.** The value is fixed in the server bundle at build time; editing the file on a running server has no effect. This is the specified behaviour; the README states it.
- **Existing global styles.** `index.astro` styles give `.btn` and other elements a `transition`. The banner must not reuse those classes (AC-7).
- **XSS through `bannerLink`.** Mitigated by the `http`/`https` protocol check; text is escaped by Astro.

## Rollback

Revert the PR commit(s). The change adds three files and edits `index.astro` and `README.md`; there is no migration, persisted data or dependency change. Setting `bannerEnabled` to `false` hides the banner without a code revert.
