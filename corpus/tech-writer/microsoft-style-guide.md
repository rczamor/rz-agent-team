---
name: Microsoft Writing Style Guide
role: tech-writer
type: organization
researched: 2026-04-16
---

# Microsoft Writing Style Guide

## Why they matter to the Tech Writer
The Microsoft Writing Style Guide is the second-most-referenced public style guide in the industry and the strongest public reference on inclusive language, UI terminology, and product-docs tone. For a Tech Writer producing Notion specs, READMEs, docstrings, API docs, and IDENTITY.md files, Microsoft's guide is the right source when the audience is broader than hardcore developers — end-user docs, PM-facing specs, onboarding guides, and anything with UI references. Its self-description — "warm and relaxed, crisp and clear, and ready to lend a hand" — is a better fit for internal team documentation than Google's terser developer-direct voice.

## Signature works & primary sources
- Microsoft Writing Style Guide (welcome) — https://learn.microsoft.com/en-us/style-guide/welcome/ — landing page with the tone statement.
- Top 10 tips for voice and style — https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice — the distilled rules; link this in any IDENTITY.md that declares a voice.
- Bias-free communication — https://learn.microsoft.com/en-us/style-guide/bias-free-communication — the industry reference for inclusive language.
- Global communications — https://learn.microsoft.com/en-us/style-guide/global-communications/ — writing for translation and non-native English readers.
- A-Z word list — https://learn.microsoft.com/en-us/style-guide/a-z-word-list-term-collections/ — the searchable terminology database.

## Core principles (recurring patterns)
- **Warm, not chummy.** Contractions are encouraged; slang and jokes are not.
- **Lead with what matters to the reader, then explain.** Action first, caveat second.
- **One idea per sentence; one topic per paragraph.**
- **Use "you" and "we" — never "the user" or "the system".**
- **Bias-free by default**: avoid gendered language, ableist idioms ("sanity check", "crazy", "dummy"), cultural assumptions, and age references. Replace master/slave with primary/replica; whitelist/blacklist with allowlist/blocklist.
- **UI terminology is precise**: "select" (not click, for multi-device), "enter" (not type), "sign in" (not log in), "OK" capitalized as a button label.
- **Prefer the verb form** over the noun form ("Configure the database" not "Database configuration").
- **Use sentence-style capitalization** in headings, titles, and UI strings.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Bias-free scan list** to run on every doc before publishing: master, slave, blacklist, whitelist, guys, manned, chairman, sanity, crazy, dummy, grandfathered, blind spot, deaf ear.
- **UI reference pattern** for step-by-step instructions: "**Select** Settings > **Accounts** > **Sign in**. **Enter** your email, and then **select** Next." Bold for UI elements, "then" with a comma before each follow-on action.
- **Voice statement for IDENTITY.md**: "This team writes in second person, active voice, present tense. Contractions are welcome. Bias-free language is required (see Microsoft Bias-Free Communication). UI elements are bold. Headings use sentence case."
- **Global-English checklist**: avoid idioms, ban culturally specific examples, prefer short sentences (<20 words), use "because" not "since" for causation, avoid phrasal verbs where a single verb exists.
- **UI terminology decision table** pinned in the team Notion: select/click, enter/type, sign in/log in, choose/pick — one choice per row, applied consistently.

## Where they disagree with others
- Microsoft vs. Google: Microsoft uses contractions and warmth; Google reads flatter and more neutral. For developer reference Google wins on terseness; for user-facing Microsoft wins on approachability.
- Microsoft vs. Chicago/AP: Microsoft uses sentence-case headings; Chicago and AP use title case. Don't mix in the same doc set.
- Microsoft vs. Stripe: Stripe is warmer and more narrative still; Microsoft is a halfway point between Google's austerity and Stripe's conversational onboarding.

## Pointers to source material
- https://learn.microsoft.com/en-us/style-guide/welcome/
- https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice
- https://learn.microsoft.com/en-us/style-guide/bias-free-communication
- https://learn.microsoft.com/en-us/style-guide/a-z-word-list-term-collections/
- Source on GitHub: https://github.com/MicrosoftDocs/microsoft-style-guide-pr
