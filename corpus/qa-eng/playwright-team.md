---
name: Microsoft Playwright Team
role: qa-eng
type: organization
researched: 2026-04-16
---

# Microsoft Playwright Team

## Why they matter to the QA Eng
Playwright is this team's E2E framework for the Next.js website and any other web UI we ship. The Playwright team at Microsoft — led historically by Andrey Lushnikov and Pavel Feldman (formerly of the Puppeteer team) — has consolidated the state of the art for cross-browser automation into one toolchain: Chromium/WebKit/Firefox in a single runner, auto-waiting, web-first retrying assertions, tracing, codegen, and a VS Code extension that makes recording/debugging E2E tests actually pleasant. Their official docs and YouTube channel are the primary reference. For this QA Eng, Playwright's defaults ARE the testing philosophy — the framework opinionates against the historical foot-guns of Selenium (manual sleeps, CSS selectors tied to markup, flaky ID-based locators).

## Signature works & primary sources
- playwright.dev — official docs, including the authoritative "Best Practices" page.
- https://playwright.dev/docs/best-practices — the canonical do's and don'ts.
- https://playwright.dev/docs/locators — locator priority and philosophy.
- https://playwright.dev/docs/test-assertions — web-first (auto-retrying) assertions.
- YouTube: https://www.youtube.com/@Playwrightdev — release walkthroughs and patterns.
- https://playwright.dev/docs/trace-viewer — the tool for diagnosing CI failures.

## Core principles (recurring patterns)
- **Test user-visible behavior, not implementation details.** Direct carryover of Dodds' principle into E2E.
- **Locator priority:** `getByRole` > `getByLabel` > `getByPlaceholder` > `getByText` > `getByTestId`. Never rely on CSS classes or XPath unless no accessible alternative exists.
- **Web-first assertions.** Use `await expect(locator).toBeVisible()` which retries until timeout, never `expect(await locator.isVisible()).toBe(true)` which snapshots once.
- **Test isolation.** Each test gets its own browser context (cookies, storage). No shared state between tests. Use `storageState` to skip auth, not to share mutable state.
- **Don't test third parties.** Mock or stub external APIs at the network layer (`page.route`). Own only what you control.
- **Trace on failure, not video.** Trace viewer (DOM snapshots + network + console per step) debugs CI failures far better than video.
- **Parallel by default, shard in CI.** Tests are independent; CI distributes shards across machines.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Page Object skeleton (minimal):** export a class that takes `page` in constructor, exposes locators as getters (`get submitButton() { return this.page.getByRole('button', { name: 'Submit' }); }`), and action methods (`async submit() { await this.submitButton.click(); }`). Don't over-engineer — Playwright's locator chaining often removes the need for POMs entirely.
- **Auth storageState pattern:** one `global-setup.ts` logs in once, saves `storageState.json`, and every test loads it via `use: { storageState: 'storageState.json' }`. Saves minutes per run.
- **Network mocking for deterministic E2E:** `await page.route('**/api/evals/**', route => route.fulfill({ json: fixture }));` — keeps E2E hermetic from backend flakiness.
- **Flaky test triage checklist:** (1) open trace viewer on the failing run, (2) check for race condition in assertions (missing `await`), (3) check for non-web-first assertions, (4) check for selectors matching multiple elements, (5) verify test isolation (leftover state), (6) only then suspect the app.
- **CI config baseline:** Linux runners, `playwright install --with-deps chromium` (skip WebKit/Firefox unless you ship to Safari users), shard count ≈ number of available cores, `retries: 2` only in CI, `trace: 'on-first-retry'`.

## Where they disagree with others
- **Playwright vs. Cypress:** Playwright supports multiple tabs/contexts/origins and Firefox+WebKit; Cypress is Chromium-only (historically) and iframe-limited. For any multi-domain or auth-redirect flow, Playwright wins.
- **Playwright vs. Selenium:** Playwright's auto-waiting and single-language (TypeScript) test authoring eliminates most of Selenium's flakiness sources.
- **Dodds-style `data-testid` vs. Playwright's `getByRole`:** Playwright docs explicitly prefer role-based locators over test IDs; test IDs are the fallback.

## Pointers to source material
- Docs: https://playwright.dev
- Best practices: https://playwright.dev/docs/best-practices
- YouTube channel: https://www.youtube.com/@Playwrightdev
- GitHub: https://github.com/microsoft/playwright (release notes are surprisingly readable).
- VS Code extension: "Playwright Test for VS Code" — run, debug, and record from the sidebar.
